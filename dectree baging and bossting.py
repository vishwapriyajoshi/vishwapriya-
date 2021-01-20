# -*- coding: utf-8 -*-
"""
Created on Wed Oct 14 07:39:25 2020

@author: Smeeta

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
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.20)

from sklearn.tree import DecisionTreeRegressor
regressor = DecisionTreeRegressor()
regressor.fit(X_train, y_train)
y_pred = regressor.predict(X_test)
df=pd.DataFrame({'Actual':y_test, 'Predicted':y_pred})

from sklearn import metrics
print('Mean Absolute Error:', metrics.mean_absolute_error(y_test, y_pred))
print('Mean Squared Error:', metrics.mean_squared_error(y_test, y_pred))
print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(y_test, y_pred)))

from sklearn.metrics import classification_report, confusion_matrix
print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))


from sklearn.ensemble import BaggingClassifier
from sklearn import tree
modesl = BaggingClassifier(tree.DecisionTreeClassifier(random_state=1))
modesl.fit(X_train, y_train)
modesl.score(X_test, y_test)

from sklearn.ensemble import AdaBoostClassifier
model = AdaBoostClassifier(random_state=1)
model.fit(X_train, y_train)
model.score(X_test,y_test)

from sklearn.ensemble import GradientBoostingClassifier
model= GradientBoostingClassifier(learning_rate=0.85,random_state=1)
model.fit(X_train, y_train)
model.score(X_test,y_test)




