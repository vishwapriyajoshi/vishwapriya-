# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 05:24:39 2021

@author: user
"""


import pandas as pd
import numpy as np
import re
import nltk
import pickle 
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline 
from matplotlib import figure

from sklearn.metrics import accuracy_score, fbeta_score,classification_report
from wordcloud import WordCloud
from nltk.tokenize import word_tokenize

from nltk.corpus import stopwords
nltk.download('stopwords')
stop = stopwords.words("english")

from nltk.stem import SnowballStemmer
ss = SnowballStemmer("english")

data = pd.read_csv('C:/Users/user/Downloads/emails.csv')
data.shape
data.columns
data = data.iloc[0:10000,3:5]
data.describe()
stop

data.groupby('Class').describe().T

data["Class"].value_counts().plot(kind = 'pie', explode = [0,0.1], figsize = (6,6), autopct = '%1.2f%%')
plt.ylabel("Abusive vs Non Abusive")
plt.legend(["Abusive", " Non Abusive"])
plt.show()

data['length']=data['content'].apply(len)
data.head()

data.length.describe()
data[data['length']== 126318]['content'].iloc[0]

data.hist(column = 'length', by = 'Class', bins = 50, figsize =(11,5))
data.head(4)

# # # # #  clean data # # # 
import string 
def cleanText (content):
    content= re.sub('[^a-zA-Z]', ' ',content)
    content = content.lower()
    content = content.split()
    words = [ss.stem(word) for word in content if word not in stop]
    return" ".join(words)

data["content"] = data["content"].apply(cleanText)
data.head(n = 10)




abusecontent = data[data["Class"] == "Abusive"]["content"]
NonAbusivecontent = data[data["Class"] == "Non Abusive"]["content"]
abusecontent
NonAbusivecontent



Abusiveword  = []
NonAbusiveword = []

def extractabusewords(abusecontent):
    global Abusiveword
    words = [word for word in word_tokenize(abusecontent)]
    Abusiveword = Abusiveword + words


def extractNonAbusivewords(nonabusecontent):
    global NonAbusiveword
    words = [word for word in word_tokenize(nonabusecontent)]
    NonAbusiveword = NonAbusiveword + words
    
 
abusecontent.apply(extractabusewords)
NonAbusivecontent.apply(extractNonAbusivewords)

Abusiveword
NonAbusiveword


######
abusewordcloud = WordCloud(width = 600, height = 400).generate(" ".join(Abusiveword))
plt.figure(figsize = (8, 8), facecolor = None) 
plt.imshow(abusewordcloud)
plt.axis("off")
plt.tight_layout(pad=0)
plt.show()


nonabusewordcloud = WordCloud(width = 600, height = 400).generate(" ".join(NonAbusiveword))
plt.figure(figsize = (8, 8), facecolor = None) 
plt.imshow(nonabusewordcloud)
plt.axis("off")
plt.tight_layout(pad=0)
plt.show()

def encondeCategory(cat):
    if cat == "Abusive":
        return 1
    else:
        return 0
    
data["Class"] = data["Class"].apply(encondeCategory)
data


###### TFIDF 

from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer()
X = cv.fit_transform(data["content"])
print(X.shape)

cv = CountVectorizer()
X = cv.fit(data["content"])
X.vocabulary_
X.get_feature_names() ## uniq variable

X = cv.fit_transform(data["content"]).toarray()
X

df = pd.DataFrame(X,columns=cv.get_feature_names())
df
df['len']= data['length']
df


y = data['Class']


from sklearn.model_selection import train_test_split
X_train,X_test,y_train,y_test = train_test_split(df, y, test_size = 0.20, random_state = 0)

from sklearn.naive_bayes import MultinomialNB
abuse_detect_model = MultinomialNB().fit(X_train, y_train)

y_pred = abuse_detect_model.predict(X_test)
print(accuracy_score(y_test, y_pred))
print(fbeta_score(y_test, y_pred,beta = 0.5))
y_pred
# # # # # confusion matrix# # # # #
print(classification_report(y_test, y_pred))


# # # # # 
savemodel = pickle.dumps(abuse_detect_model)
modelfrom_pickle = pickle.loads(savemodel)
y_pred = modelfrom_pickle.predict(X_test)
print(accuracy_score(y_test,  y_pred))

import joblib
joblib.dump(abuse_detect_model, 'pickless')
joblib.dump(cv, 'transforms.pk')
