# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np
import pandas as pd
from keras.models import Sequential
from keras.layers import Dense, Activation,Layer,Lambda

from sklearn.model_selection import train_test_split

data = pd.read_csv("C:/Users/user/Downloads/forestfires.csv")


data['size_category'] = pd.factorize(data['size_category'])[0]
fires= data[['temp','RH','wind','rain']]

fires.head()
fires.columns
fires.shape
fires.isnull().sum() 



def prep_model(hidden_dim):
    model = Sequential()
    for i in range(1,len(hidden_dim)-1):
        if (i==1):
            model.add(Dense(hidden_dim[i],input_dim=hidden_dim[0],kernel_initializer="normal",activation="relu"))
        else:
            model.add(Dense(hidden_dim[i],activation="relu"))
    model.add(Dense(hidden_dim[-1]))
    model.compile(loss="mean_squared_error",optimizer="adam",metrics = ["accuracy"])
    return (model)

column_names = list(fires.columns)
predictors = column_names[0:4]
target = column_names[1]

first_model = prep_model([4,11,1])
first_model.fit(np.array(fires[predictors]),np.array(fires[target]),epochs=50)
pred_train = first_model.predict(np.array(fires[predictors]))
pred_train = pd.Series([i[0] for i in pred_train])
rmse_value = np.sqrt(np.mean((pred_train-fires[target])**2))

import matplotlib.pyplot as plt
plt.plot(pred_train,fires[target],"bo")
np.corrcoef(pred_train,fires[target]) # we got high correlation 


