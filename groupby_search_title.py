import pandas as pd
import collections
import re
def func(s):
    skills=s.split(", ")
    skill_freq_dict = collections.Counter(skills)
    skill_freq=skill_freq_dict.most_common()
    s = skill_freq
    return s

def computeAvrgFreq(l):
    if len(l)==0: return 0
    s=0
    for e in l:
        s+=e[1]
    return s/len(l)
def dropRareSkill(l):
    res = [i for i in l if i[1]>=10]
    return res

def groupbyTitle(df):
    df['required_skills'] = df['required_skills'].astype('string')
    df.dropna(inplace=True)
    df = df.groupby('job_title', as_index=False)['required_skills'].apply(", ".join)
    df['required_skills']=df['required_skills'].apply(func)
    df['required_skills']=df['required_skills'].map(dropRareSkill)
    df = df.drop(df[df["required_skills"].apply(computeAvrgFreq)<=1].index)

    df.to_csv("all_jobs_formatted_groupedByTitle_dropped.csv")

df = pd.read_csv("all_jobs_formatted_with_matched_titles.csv", encoding = "ISO-8859-1")
groupbyTitle(df)



