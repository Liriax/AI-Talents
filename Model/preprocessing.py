import re
import pandas as pd
import numpy as np
from fuzzywuzzy import fuzz, process
import collections

# Cleans skills and return as string
def formatSkill(text):
    text = text.replace("\n", ",")
    text = text.replace("-", ",")
    text = text.replace("(", "")
    text = text.replace("\"", "")
    text = text.replace("\'", "")
    text = text.replace(")", "")
    text = text.lower()
    text = re.sub("/", ",", text)
    text = re.sub("and ", ",", text)
    text = text.split('skill', 1)[0]
    text = text.strip()
    skills = re.split(', |,', text)
    skills = [skill for skill in skills if len(skill.split())<4]
    for skill in skills:
        if skill=="nan" or len(skill)==0 or "see" in skill or skill.endswith("ing") or skill.endswith("yst") or skill.endswith("or") or skill.endswith("ist") or skill.endswith("ant") or (skill.endswith("er") and not skill.endswith("ver"))or skill=="project" or skill == "research" :
            skills.remove(skill)
            continue
    for skill in skills:
        skill = skill.strip()

    if skills == []: text = np.nan
    else: text = str(', '.join(skills))
    return text

# cleans titles
def formatTitle(title):
    title = title.lower()
    title = re.sub("[\(\[].*?[\)\]]", "", title)
    title = title.split('-', 1)[0]
    title = title.replace('the', "")
    title = title.split(', ', 1)[0]
    title = title.split(' with ', 1)[0]
    title = title.replace(".", "")
    title = re.sub("sr", "", title)
    title = re.sub("senior", "", title)
    title = title.strip()
    title = sorted(title.split('/'), key=(lambda x: len(x.split())), reverse=True)[0]
    if len(title.split())>4 or len(title.split())<2: title = ""
    return title

# Apply cleaning to both titles and skills
def formatWithoutGrouping(filename):
    data = pd.read_csv(filename+".csv", encoding = "ISO-8859-1")# , dtype={"search_title": str, "job_title": str, "required_skills": str})
    data["job_title"]=[formatTitle(x) if isinstance(x, str) else x for x in data["job_title"]]
    data["required_skills"]=[str(x) for x in data["required_skills"]]
    data["required_skills"]=[formatSkill(x) for x in data["required_skills"]]
    data['job_title'].replace('', np.nan, inplace=True)
    data.dropna(inplace=True)
    data.to_csv(filename+"_formattedWithoutGrouping.csv", index=False)

def groupSameSearchTitle(filename):
    data = pd.read_csv(filename+".csv", encoding = "ISO-8859-1")
    data.dropna(inplace=True)
    data["job_title"]=[formatTitle(x) if isinstance(x, str) else x for x in data["job_title"]]
    data['required_skills'] = data.groupby(['search_title'])['required_skills'].transform(lambda x : ', '.join(x)) 
    data['job_title'] = data.groupby(['search_title'])['job_title'].transform(lambda x : ', '.join(x))
    data["job_title"]=[x.split(", ") if isinstance(x, str) else x for x in data["job_title"]]
    data["job_title"]=[list(filter(None, x)) for x in data["job_title"]]
    
    data["search_title"]= data["search_title"].str.replace("+", " ")
    data["required_skills"]=[formatSkill(x) if isinstance(x, str) else x for x in data["required_skills"]]
    
    data = data.drop_duplicates(["search_title"])    
    
    data.to_csv(filename + "_formattedGrouped.csv", index=False)

'''
# Format both datasets and combine them
formatWithoutGrouping("dice_com-job2017")
formatWithoutGrouping("job_title_skills 2020")
data1 = pd.read_csv("dice_com-job2017_formattedWithoutGrouping.csv", encoding = "ISO-8859-1")
data2 = pd.read_csv("job_title_skills 2020_formattedWithoutGrouping.csv", encoding = "ISO-8859-1")
df=pd.concat([data1.drop(["jobdescription"], axis=1), data2.drop(["search_title"], axis=1)])
#df.to_csv("all_jobs_formatted.csv", index=False)
'''


def func(s):
    skills=s.split(", ")
    skill_freq = collections.Counter(skills).most_common()
    s = skill_freq
    return s

# returns a dictionary that maps skill to its count in the dataset
def getSkillFreqDict(df):
    skills = []
    for skill_set in df['required_skills']:
        skill_set=str(skill_set)
        for skill in skill_set.split(", "):
            skills.append(skill)
    return collections.Counter(skills)

# returns a dictionary that maps job title to its count in the dataset
def getJobFreqDict(df):
    jobs = []
    for job in df['job_title']:
        jobs.append(job)
    return collections.Counter(jobs)

# Prints top 20 jobs and number of unique skills and skills that only appear once
def statistics(df):
    job_freq = getJobFreqDict(df)
    job_occur = job_freq.most_common()
    print(job_occur[:20])

    skill_freq = getSkillFreqDict(df)
    print("There are these many unique skills: "+ str(len(skill_freq)))
    rare_skills_dict = { key:value for (key,value) in skill_freq.items() if value < 2}
    print("There are these many rare skills: "+ str(len(rare_skills_dict)))


def returnNonRareSkill(dic, l):
    if not isinstance(l, str): l=str(l)
    res = [i for i in l.split(", ") if dic.get(i)>9]
    if res==[]: return np.nan
    return ', '.join(res)

# drops all rare skills from the dataset   
def dropRareSkill(df):
    dic = getSkillFreqDict(df)
    df['required_skills']=df['required_skills'].apply(lambda x: returnNonRareSkill(dic, x))
    df.dropna(inplace=True)
    
def dropRareTitle(df):
    df['job_title_frequency'] = df['job_title'].map(getJobFreqDict(df))
    df = df.drop(df[df.job_title_frequency < 100].index)
    
def fuzzyMatchTitle(df):
    
    with open('it_jobs.txt') as f:
        it_jobs = [i.strip() for i in f.readlines()]
    dic = {}
    for job in df['job_title']:
        tup = process.extractOne(job,it_jobs)
        if tup[1]>80:
            highest = tup[0].replace("+", " ")        
            dic.update({job: highest})
        else: dic.update({job: ""})
    with open('job_dict.txt', 'w') as f:
        print(dic, file=f)
    df.replace(dic, inplace=True)

def RelatedWordsJobTitle(word):
    related = []
    for index, row in df.iterrows():
        if word in row['job_title']:
            for w in row['job_title'].split():
                related.append(w)
    top_words = collections.Counter(related).most_common()
    print(top_words[:50])

def findSimilarJobTitle(title):
        new_title = np.nan
        if "software" in title:
            new_title = "software engineer"
        elif "project" in title:
            new_title = "project manager"
        elif "data"in title or "sql" in title:
            if "database" in title:
                new_title = "database administrator"
            elif "big" in title:
                new_title = "big data engineer"
            else: new_title = "data analyst"
        elif "intelligence" in title:
            new_title = "business intelligence analyst"
        elif "java" in title: new_title = "java developer"
        elif "security" in title:
            if "information" in title:
                new_title = "information security analyst"
            else: new_title = "security architect"
        elif "net" in title: new_title = "network engineer"
        elif "support" in title or "help" in title: new_title = "IT support"
        elif "application" in title: new_title = "application developer"
        elif "information" in title: new_title = "information systems coordinater"
        elif "oracle" in title or "database" in title: new_title = "database administrator"
        elif "web" in title: new_title = "web developer"
        if "cloud" in title: new_title = "cloud engineer"
        if "devops" in title: new_title = "DevOps engineer"
        if "ui" in title or "ux" in title or "user" in title: new_title = "UX designer"
        if "qa" in title or "quality" in title or "assurance" in title: new_title = "quality assurance engineer"
        if "hardware" in title: new_title = "hardware engineer"

        return new_title
def selectJobs(df):
    for index, row in df.iterrows():
        title = row['job_title']
        new_title = findSimilarJobTitle(title)
        df.at[index,'job_title'] = new_title
    df.dropna(inplace=True)

    
def score(t1, t2):
    return DISTANCE(set(t1.split()), set(t2.split()))

from cluster import HierarchicalClustering
def hierarClustering(threshold):
    DISTANCE_THRESHOLD = threshold # threshold is between 0 to 1
    DISTANCE = jaccard_distance
    jobs=[]
    for index, row in df.iterrows(): 
        jobs.append(row.job_title)
    jobs = list(set(jobs))
    hc = HierarchicalClustering(jobs, score)
    clusters = hc.getlevel(DISTANCE_THRESHOLD)
    clusters = [c for c in clusters if len(c) > 1]
    
def findTopSkillsFromJob(df, job):
    n=0
    skills=[]
    stop_words = ["development", "management", "analysis"]
    for index, row in df.iterrows(): 
        if row.job_title == job:
            n+=1
            for skill in row.required_skills.split(', '):
                skills.append(skill)
    top_skills = collections.Counter(skills).most_common()[:5]
    perc = []
    for skill, count in top_skills:
        if skill not in job and skill not in stop_words:
            perc.append((skill, count/n))
    print("The top skills for " + job + " are: ")
    for skill, prob in perc:
        print(skill + " with " + str(int(100*prob))+ " percent probability")
    return perc

#df = pd.read_csv("test.csv", encoding = "ISO-8859-1")
#findTopSkillsFromJob(df, "software engineer")

    
