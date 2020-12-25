import pandas as pd
from fuzzywuzzy import fuzz, process
import collections
import numpy as np


def func(s):
    skills=s.split(", ")
    skill_freq = collections.Counter(skills).most_common()
    s = skill_freq
    return s
def getSkillFreqDict(df):
    skills = []
    for skill_set in df['required_skills']:
        skill_set=str(skill_set)
        for skill in skill_set.split(", "):
            skills.append(skill)
    return collections.Counter(skills)
def statistics(df):
    job_titles = []

    for job in df['job_title']:
        job_titles.append(job)
        
    job_freq = collections.Counter(job_titles)
    job_occur = job_freq.most_common()
    print(job_occur[:20])

    skill_freq = getSkillFreqDict(df)
    print("There are these many unique skills: "+ str(len(skill_freq)))
    rare_skills_dict = { key:value for (key,value) in skill_freq.items() if value < 2}
    print("There are these many rare skills: "+ str(len(rare_skills_dict)))
    
def dropRareSkill(dic, l):
    if not isinstance(l, str): l=str(l)
    res = [i for i in l.split(", ") if dic.get(i)>9]
    if res==[]: return np.nan
    return ', '.join(res)

df =pd.read_csv("all_jobs_formatted_with_matched_titles.csv", encoding = "ISO-8859-1")
statistics(df)

dic = getSkillFreqDict(df)
df['required_skills']=df['required_skills'].apply(lambda x: dropRareSkill(dic, x))
df.dropna(inplace=True)
statistics(df)

df.to_csv("all_jobs_formatted_with_matched_titles_rareDropped.csv", index=False)


'''
dat = pd.read_csv("search_title_grouped.csv", encoding = "ISO-8859-1")
dat['required_skills']=dat['required_skills'].apply(func)
dat.to_csv("search_title_grouped_with_freq.csv")

 
df = pd.read_csv("all_jobs_formatted.csv", encoding = "ISO-8859-1")


with open('it_jobs.txt') as f:
    it_jobs = [i.strip() for i in f.readlines()]

dic = {}
for job in df['job_title']:
    highest = process.extractOne(job,it_jobs)[0].replace("+", " ")
    dic.update({job: highest})

df.replace(dic, inplace=True)
df.to_csv("all_jobs_formatted_with_matched_titles.csv")




with open('common_skills.txt', 'rb') as f:
    common_skills = [i.strip() for i in f.readlines()]


dic = {}
bad_skills_dict = { key:value for (key,value) in skill_freq.items() if value==1}

for skill in rare_skills_dict.keys():
    highest = process.extractOne(skill,common_skills)
    if highest[1]>=80:
        dic.update({skill: highest[0]})
    else:
        dic.update({skill: ""})

with open('skill_dict.txt', 'w') as f:
    print(dic, file=f)


df = df.drop(df[df.job_title_frequency < 10].index)
df=df.drop(['job_title_frequency'], axis=1)
df['required_skills'] = df['required_skills'].astype('string')
df.dropna(inplace=True)
df = df.groupby('job_title', as_index=False)['required_skills'].apply(", ".join)
df['required_skills']=df['required_skills'].apply(func)
df.to_csv("all_jobs_formatted_rare_titles_dropped.csv")
'''

