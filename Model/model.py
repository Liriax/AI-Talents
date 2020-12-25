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

def my_tokenizer(s):
    return s.split(', ')

df = pd.read_csv('data.csv', encoding="ISO-8859-1")
df = df.loc[(df['job_title'] == 'data scientist' )|( df['job_title'] == 'software engineer') | (df['job_title'] == 'java developer')]
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
#td = TfidfTransformer()
#X = td.fit_transform(X)
# feature selection
fs = ExtraTreesClassifier(n_estimators=50)
fs=fs.fit(X, labels_en)
    #print(fs.feature_importances_)
model = SelectFromModel(fs, prefit=True, max_features=800)
#dump(model, 'feature_selecter.joblib')

#X = model.transform(X)

x_train, x_test, y_train, y_test = train_test_split(X, labels_en)
# train model

clf = MultinomialNB().fit(x_train, y_train)
#dump(clf, 'model1.joblib')

# make a prediction
docs_new = ['sql, r, machine learning']
#X_new = model.transform(vectorizer.transform(docs_new))
X_new = vectorizer.transform(docs_new)
predicted = clf.predict(X_new)
#print(str(docs_new) + "->" + str(le.inverse_transform(predicted)))

# Evaluate
predicted = clf.predict(x_test)

#print("Evaluation: " + str(np.mean(predicted == y_test)))
