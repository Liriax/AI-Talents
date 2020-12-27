import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.model_selection import train_test_split
from sklearn import preprocessing
from category_encoders import BinaryEncoder
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.feature_selection import SelectFromModel
from sklearn.pipeline import Pipeline
from sklearn.naive_bayes import MultinomialNB
from joblib import dump, load
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.feature_selection import f_classif
from sklearn.ensemble import AdaBoostClassifier



def my_tokenizer(s):
    return s.split(', ')

df = pd.read_csv('test.csv', encoding="ISO-8859-1")
#df = df.loc[(df['job_title'] == 'data scientist' )|( df['job_title'] == 'software engineer') | (df['job_title'] == 'java developer')]
#df = pd.read_csv('data_rare_titles_dropped.csv', encoding="ISO-8859-1")
#df = df[df['required_skills'].map(lambda x: len(x.split(", "))) >= 2]

#df.to_csv("d.csv")

data=[]
labels=[]

# Iterate over each row 
for index, row in df.iterrows(): 
    labels.append(row.job_title)
    data.append(row.required_skills) 

# encode labels
le = preprocessing.LabelEncoder()
labels_en = le.fit_transform(labels) 

x1, x2, y1, y2 = train_test_split(data, labels)

# vectorize data
vectorizer = CountVectorizer(tokenizer=my_tokenizer)
#dump(vectorizer, 'vec.joblib')

X = vectorizer.fit_transform(data)
td = TfidfTransformer()
X = td.fit_transform(X)
# feature selection
fs = ExtraTreesClassifier(n_estimators=50).fit(X, labels_en)
sfm = SelectFromModel(fs, prefit=True)
#X = sfm.transform(X)
#X=SelectKBest(f_classif,k=200).fit_transform(X, labels_en)
#dump(model, 'feature_selecter.joblib')


x_train, x_test, y_train, y_test = train_test_split(X, labels_en)
# train model
neigh = KNeighborsClassifier(n_neighbors=3).fit(x_train, y_train)
svm = SVC().fit(x_train, y_train)
clf = MultinomialNB().fit(x_train, y_train)
ada = AdaBoostClassifier(n_estimators=100, random_state=0).fit(x_train, y_train)
#dump(clf, 'model1.joblib')


#print(str(docs_new) + "->" + str(le.inverse_transform(predicted)))
'''
# Evaluate
print("KNN: "+ str(neigh.score(x_test, y_test)))
print("SVM: "+ str(svm.score(x_test, y_test)))
print("NB: "+ str(clf.score(x_test, y_test)))
print("Ada: "+ str(ada.score(x_test, y_test)))
'''
