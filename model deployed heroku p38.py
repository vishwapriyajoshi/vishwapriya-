# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 05:24:43 2021

@author: user
"""

# # # # # 

from flask import Flask,render_template,url_for,request
import pickle
import joblib

   
   
   
filename = 'pickle'
clf = joblib.load(open(filename, 'rb'))
cv=joblib.load(open('transform', 'rb'))

app=Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def home():
    return render_template('home.htm')

@app.route('/predict', methods=['GET', 'POST'])
def predict():
    if request.method=='POST':
        message= request.form['message']
        data= [message]
        vect= cv.transform(data).toarray()
        my_prediction=clf.predict(vect)
    return render_template('result.htm', prediction =my_prediction)


if __name__=='__main__':
    app.run(debug=True)
     