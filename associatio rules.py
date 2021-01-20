# -*- coding: utf-8 -*-
"""
Created on Wed Nov 25 22:57:11 2020

@author: user
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

from mlxtend.frequent_patterns import apriori,association_rules

data = pd.read_csv("C:/Users/user/Downloads/book.csv")


frequent_itemsets = apriori(data, min_support=0.005, max_len=3,use_colnames = True)

# Most Frequent item sets based on support 
frequent_itemsets.sort_values('support',ascending = False,inplace=True)

rules = association_rules(frequent_itemsets, metric="lift", min_threshold=1)
rules.head(20)
rules.sort_values('lift',ascending = False,inplace=True)

 
def to_list(i):
    return (sorted(list(i)))


ma_X = rules.antecedents.apply(to_list)+rules.consequents.apply(to_list)


ma_X = ma_X.apply(sorted)

rules_sets = list(ma_X)

unique_rules_sets = [list(m) for m in set(tuple(i) for i in rules_sets)]
index_rules = []
for i in unique_rules_sets:
    index_rules.append(rules_sets.index(i))


# getting rules without any redudancy 
rules_no_redudancy  = rules.iloc[index_rules,:]

# Sorting them with respect to list and getting top 10 rules 
rules_no_redudancy.sort_values('lift',ascending=False).head(10)