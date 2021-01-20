# -*- coding: utf-8 -*-
"""
Created on Wed Dec 30 23:02:50 2020

@author: preethi.v
"""

import spacy
# For regular expressions
import re
# For handling string
import string
# For performing mathematical operations
import math
import nltk
from nltk.corpus import stopwords
import string
import matplotlib.pyplot as plt
from flask import Flask,render_template,url_for,request
import pandas as pd 
import pickle
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB

import joblib
app = Flask(__name__)

@app.route('/')
def home():
	return render_template('home.html')
@app.route('/predict',methods=['POST'])
def predict():
    emails=pd.read_csv('C:/Users/user/Downloads/emails.csv')
    mails = emails[:10000]
	#dropping duplicate records in the data
    mails.drop_duplicates(inplace=True)
    mails.drop(['Unnamed: 0', 'filename', 'Message-ID'], axis=1, inplace=True)

    mails['cleaned'] = mails['content'].apply(lambda x:x.lower())
    mails['cleaned']=mails['cleaned'].apply(lambda x: re.sub('\w*\d\w*','', x))
    mails['cleaned']=mails['cleaned'].apply(lambda x: re.sub('[%s]' % re.escape(string.punctuation), '', x))
    # Removing extra spaces
    mails['cleaned']=mails['cleaned'].apply(lambda x: re.sub(' +',' ',x))
    # Loading model
    nlp = spacy.load('en_core_web_sm',disable=['parser', 'ner'])
    # Lemmatization with stopwords removal
    mails['lemmatized']=mails['cleaned'].apply(lambda x: ' '.join([token.lemma_ for token in list(nlp(x)) if (token.is_stop==False)]))
# Features and Labels
    mails['Class'].head(100)
    mails['label'] = mails['Class'].map({'Non Abusive': 0, 'Abusive': 1})
    mails.columns
    mails.label.head(100)
    X = mails['content']
    y = mails['label']
	
	# Extract Feature With CountVectorizer
    cv = CountVectorizer()
    X = cv.fit_transform(X) # Fit the Data
    from sklearn.model_selection import train_test_split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)
	#Naive Bayes Classifier
    from sklearn.naive_bayes import MultinomialNB

    clf = MultinomialNB()
    clf.fit(X_train,y_train)
    clf.score(X_test,y_test)	
    #Alternative Usage of Saved Model
	# joblib.dump(clf, 'NB_spam_model.pkl')
	# NB_spam_model = open('NB_spam_model.pkl','rb')
	# clf = joblib.load(NB_spam_model)

    if request.method == 'POST':
        message = request.form['message']
        data = [message]
        vect = cv.transform(data).toarray()
        my_prediction = clf.predict(vect)
    return render_template('result.html',prediction = my_prediction)
    #return "Hello, World!"
if __name__ == '__main__':
	app.run()