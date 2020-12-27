from model import svm, vectorizer, le, td, sfm
from preprocessing import findTopSkillsFromJob, findSimilarJobTitle
import numpy as np
import pandas as pd
# Functions
def getUserInput():
    skills = input("What are your skills? Please separate with comma: ")
    job = input("What is your current job position?")
    return (skills, job)

def predict_res(skills):
    inp = [skills]
    res = svm.predict(td.transform(vectorizer.transform(inp)))
    out = le.inverse_transform(res)
    result="You could also be a " + out[0]
    print(result)
    
def findSkillGap(job, skills):
    perc = findTopSkillsFromJob(df, job)
    should = {}
    gap = []
    for skill, per in perc:
        should.update({skill:per})
    for skill in skills.split(', '):
        if skill not in should.keys():
            gap.append(skill)
    print("Your skill gaps are: " + str(gap))


df = pd.read_csv("test.csv", encoding = "ISO-8859-1")
tup = getUserInput()
skills = tup[0]
input_job = tup[1]
job = findSimilarJobTitle(input_job)
predict_res(skills)
if job!=np.nan:
    findSkillGap(job, skills)
else: print("Sorry, job title not supported yet!")

