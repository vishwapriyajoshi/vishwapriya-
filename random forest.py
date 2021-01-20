# -*- coding: utf-8 -*-
"""
Created on Sat Nov 21 04:53:36 2020

@author: user
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


data = pd.read_csv("C:/Users/user/Downloads/Company_data.csv")
data.head()
data.isnull().sum()
data = data.dropna()
data.isnull().sum()
data.head()

import sklearn
data['Urban'] = pd.factorize(data['Urban'])[0]
data['ShelveLoc'] = pd.factorize(data['ShelveLoc'])[0]
data['US'] = pd.factorize(data['US'])[0]

X = data.drop('ShelveLoc', axis=1)
y = data['ShelveLoc']

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics
import seaborn as sn
import matplotlib.pyplot as plt

X_train,X_test,y_train,y_test = train_test_split(X,y,test_size=0.25,random_state=0)

clf = RandomForestClassifier(n_estimators=100)
clf.fit(X_train,y_train)
y_pred=clf.predict(X_test)
confusion_matrix = pd.crosstab(y_test, y_pred, rownames=['Actual'], colnames=['Predicted'])
sn.heatmap(confusion_matrix, annot=True)
print('Accuracy: ',metrics.accuracy_score(y_test, y_pred))
plt.show()



