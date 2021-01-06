#from model import svm, vectorizer, le, td, sfm
import numpy as np
import pandas as pd
import collections
from joblib import load

def my_tokenizer(s):
     l = []
     for e in s.split(','):
       l.append(e.strip())
     return l
    #return s.split(', ')
    
svm = load('svm_model.joblib')
vectorizer = load('vec.joblib')
le = load('label_encoder.joblib')
td = load('td.joblib')

# Functions

      
def findSimilarJobTitle(title):
        new_title = ""
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
        
def findAllTopSkillsFromJob(df, job):
    n=0
    skills=[]
    stop_words = ["development", "management","technician", "analysis", "data", "it", "systems", "software"]
    for index, row in df.iterrows(): 
        if row.job_title == job:
            n+=1
            for skill in row.required_skills.split(','):
                skills.append(skill.strip())
    top_skills = collections.Counter(skills).most_common()
    perc = []
    for skill, count in top_skills:
        if skill not in job and skill not in stop_words:
            perc.append((skill, count/n))
    return perc
    
    
def getNTopSkillsFromJob(df, job, n):
  l = findAllTopSkillsFromJob(df, job)
  skills = []
  freq = []
  i = 0
  for skill, perc in l:
    if i>=n: break
    skills.append(skill)
    freq.append(perc)
    i+=1
  df = pd.DataFrame(list(zip(skills, freq)), columns = ['skills','frequency'])
  # df.to_csv("result.csv", encoding = "ISO-8859-1")

  return df

def predict_res(skills):
    inp = [skills]
    res = svm.predict(td.transform(vectorizer.transform(inp)))
    out = le.inverse_transform(res)
    return str(out[0])



def getSkillGapAndFreq(df, job, skills, n_skills):
    df = getNTopSkillsFromJob(df, job, n_skills)
    should = {}
    gap = []
    for index, row in df.iterrows(): 
      skill = row.skills
      perc = row.frequency
      should.update({skill:perc})
    n = 0
    total = sum(should.values())
    assert total!=0
    for skill in should.keys():
        if skill not in skills.split(','):
            skill=skill.strip()
            gap.append(skill)
            n+=should.get(skill)
    percentage_away = int(n/total*100)
    return (gap, percentage_away)
    
def findSkillGap(df, job, skills, n_skills):
    tup = getSkillGapAndFreq(df, job, skills, n_skills)
    gap = tup[0]
    percentage_away = tup[1]
    if len(gap)>0: return ', '.join(gap)# + " and you are "+ str(percentage_away) + " percent away"
    else: return "None"
    
def findSkillGapPercentage(df, job, skills, n_skills):
    tup = getSkillGapAndFreq(df, job, skills, n_skills)
    gap = tup[0]
    percentage_away = tup[1]
    return percentage_away
    
def getSkillGapList(df, job, skills, n_skills):
    time = pd.read_csv("Skill_times.csv", encoding = "ISO-8859-1")
    time.dropna(inplace=True)
    time = time.sort_values(by=['Skill_time'])
    tup = getSkillGapAndFreq(df, job, skills, n_skills)

    gap = tup[0]
    skills = []
    hours = []
    for index, row in time.iterrows():
      skill = row.Skill
      hr = row.Skill_time
      if skill in gap:
        skills.append(skill)
        hours.append(int(hr))
    res = pd.DataFrame(list(zip(skills, hours)), columns = ['skill','time'])
    res.to_csv("result2.csv", encoding = "ISO-8859-1")
    
def getTeamSkillGap(df, team, n):
  team_skill_gap = []
  for index, row in team.iterrows():
    job = row.position
    skills = row.skills
    job = findSimilarJobTitle(job)
    if job == "": continue
    tup = getSkillGapAndFreq(df, job, skills, n)
    gap = tup[0]
    team_skill_gap = team_skill_gap + gap
  return team_skill_gap
