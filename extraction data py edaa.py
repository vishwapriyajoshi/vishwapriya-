# -*- coding: utf-8 -*-
"""
Created on Fri Dec  4 01:03:35 2020

@author: user
"""
import pandas as pd
import requests   # Importing requests to extract content from a url
from bs4 import BeautifulSoup as bs # Beautifulsoup is for web scrapping...used to scrap specific content 
import re 

url ="https://www.amazon.in/OnePlus-Nord-Marble-256GB-Storage/product-reviews/B0869855B8/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews"
response = requests.get(url)
response.content
soup = bs(response.content,'html.parser')
print(soup.prettify())
namess = soup.find_all('span', class_="a-profile-name")

cust_name =[]
for i in range(0,len(namess)):
    cust_name.append(namess[i].get_text())
cust_name
cust_name.pop(0)
cust_name.pop(0)
title = soup.find_all('a',class_='review-title-content')

review_title =[]
for i in range(0,len(title)):
    review_title.append(title[i].get_text())
review_title
review_title[:] =[titles.lstrip('\n') for titles in review_title ]
review_title[:] =[titles.rstrip('\n') for titles in review_title ]

rating = soup.find_all('i',class_='review-rating')
rate =[]
for i in range(0,len(rating)):
    rate.append(rating[i].get_text())
rate
len(rate)
rate.pop(0)

review = soup.find_all("span",{"data-hook":"review-body"})
review_content =[]
for i in range(0,len(review)):
    review_content.append(review[i].get_text())
review
review_content[:] =[reviews.lstrip('\n') for reviews in review_content ]
review_content[:] =[reviews.rstrip('\n') for reviews in review_content ]
len(review_content)

cust_name 
review_title
rate
review_content

extractdf = pd.DataFrame()
extractdf
extractdf['Customer Name']=cust_name 
extractdf['Review Title']=review_title
extractdf['Rate']=rate
extractdf['Reviews Content']=review_content

#extractdf.to_csv(r'C:/Users/user/Desktop/python complete assignment/extractiondatamazon.csv',index=True)

with open("amazon.txt","w",encoding='utf8') as output:
    output.write(str(review_content))

import pandas as pd 
import re 
import nltk
from nltk.corpus import stopwords
from wordcloud import WordCloud


ip_rev_string = " ".join(review_content)

ip_rev_string = re.sub("[^A-Za-z" "]+"," ",ip_rev_string).lower()
ip_rev_string = re.sub("[0-9" "]+"," ",ip_rev_string)


# words that contained in iphone 7 reviews
ip_reviews_words = ip_rev_string.split(" ")


stop_words = stopwords.words('english')


with open("C:/Users/user/Desktop/python complete assignment/extractiondatamazon","r") as sw:
    stopwords = sw.read()


wordcloud_ip = WordCloud(
                      background_color='black',
                      width=1800,
                      height=1400
                     ).generate(ip_rev_string)

plt.imshow(wordcloud_ip)


ip_neg_in_neg = " ".join ([w for w in ip_reviews_words if w in negwords])

wordcloud_neg_in_neg = WordCloud(
                      background_color='black',
                      width=1800,
                      height=1400
                     ).generate(ip_neg_in_neg)

plt.imshow(wordcloud_neg_in_neg)















