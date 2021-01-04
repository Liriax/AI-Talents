#from model import svm, vectorizer, le, td
from preprocessing import findTopSkillsFromJob, findSimilarJobTitle
import numpy as np
import pandas as pd
from joblib import load

def my_tokenizer(s):
    return s.split(', ')

svm = load('svm_model.joblib')
vectorizer = load('vec.joblib')
le = load('label_encoder.joblib')
td = load('td.joblib')



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

