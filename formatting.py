import re
import pandas as pd
import numpy as np
import seaborn as sns
from _overlapped import NULL
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
filename = "dice_com-job2017"
formatWithoutGrouping(filename)
formatWithoutGrouping("job_title_skills 2020")
data1 = pd.read_csv("dice_com-job2017_formattedWithoutGrouping.csv", encoding = "ISO-8859-1")
data2 = pd.read_csv("job_title_skills 2020_formattedWithoutGrouping.csv", encoding = "ISO-8859-1")
df=pd.concat([data1.drop(["jobdescription"], axis=1), data2.drop(["search_title"], axis=1)])
df.to_csv("all_jobs_formatted.csv", index=False)

#print(df['required_skills'].value_counts())

'''
filename = "all_jobs_formatted_with_matched_titles_rareDropped"
formatWithoutGrouping(filename)

