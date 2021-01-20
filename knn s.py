# -*- coding: utf-8 -*-
"""
Created on Wed Nov 25 05:53:30 2020

@author: user
"""

# Importing Libraries 
import pandas as pd
import numpy as np


data = pd.read_csv("C:/Users/user/Downloads/Zoo.csv")

data.drop(['animal name'], axis=1,inplace = True)

data['hair'] = pd.factorize(data['hair'])[0]
data['feathers'] = pd.factorize(data['feathers'])[0]
data['eggs'] = pd.factorize(data['eggs'])[0]
data['milk'] = pd.factorize(data['milk'])[0]
data['airborne'] = pd.factorize(data['airborne'])[0]
data['aquatic'] = pd.factorize(data['aquatic'])[0]
data['predator'] = pd.factorize(data['predator'])[0]
data['toothed'] = pd.factorize(data['toothed'])[0]
data['backbone'] = pd.factorize(data['backbone'])[0]
data['breathes'] = pd.factorize(data['breathes'])[0]
data['venomous'] = pd.factorize(data['venomous'])[0]
data['fins'] = pd.factorize(data['fins'])[0]
data['legs'] = pd.factorize(data['legs'])[0]
data['tail'] = pd.factorize(data['tail'])[0]
data['domestic'] = pd.factorize(data['domestic'])[0]
data['catsize'] = pd.factorize(data['catsize'])[0]
data['type'] = pd.factorize(data['type'])[0]




# Training and Test data using 
from sklearn.model_selection import train_test_split
train,test = train_test_split(data,test_size = 0.2) # 0.2 => 20 percent of entire data 

# KNN using sklearn 
# Importing Knn algorithm from sklearn.neighbors
from sklearn.neighbors import KNeighborsClassifier as KNC

# for 3 nearest neighbours 
neigh = KNC(n_neighbors= 3)

# Fitting with training data 
neigh.fit(train.iloc[:,0:17],train.iloc[:,16])

# train accuracy 
train_acc = np.mean(neigh.predict(train.iloc[:,0:17])==train.iloc[:,16]) # 94 %

# test accuracy
test_acc = np.mean(neigh.predict(test.iloc[:,0:17])==test.iloc[:,16]) # 100%


# for 5 nearest neighbours
neigh = KNC(n_neighbors=5)

# fitting with training data
neigh.fit(train.iloc[:,0:17],train.iloc[:,16])

# train accuracy 
train_acc = np.mean(neigh.predict(train.iloc[:,0:17])==train.iloc[:,16])

# test accuracy
test_acc = np.mean(neigh.predict(test.iloc[:,0:17])==test.iloc[:,16])

# creating empty list variable 
acc = []

# running KNN algorithm for 3 to 50 nearest neighbours(odd numbers) and 
# storing the accuracy values 
 
for i in range(3,50,2):
    neigh = KNC(n_neighbors=i)
    neigh.fit(train.iloc[:,0:17],train.iloc[:,16])
    train_acc = np.mean(neigh.predict(train.iloc[:,0:17])==train.iloc[:,16])
    test_acc = np.mean(neigh.predict(test.iloc[:,0:17])==test.iloc[:,16])
    acc.append([train_acc,test_acc])


import matplotlib.pyplot as plt # library to do visualizations 

# train accuracy plot 
plt.plot(np.arange(3,50,2),[i[0] for i in acc],"bo-")

# test accuracy plot
plt.plot(np.arange(3,50,2),[i[1] for i in acc],"ro-")

plt.legend(["train","test"])



