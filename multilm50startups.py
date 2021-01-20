# -*- coding: utf-8 -*-
"""
Created on Tue Oct 13 10:58:44 2020

@author: Smeeta
"""

 #Multilinear Regression
import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt

# loading the data
startups = pd.read_csv("C:/Users/Smeeta/Downloads/50_Startups.csv")
start= startups.rename(columns={"R&D Spend":"Rdspend",  "Marketing Spend":"marketingspend" })
start= start.drop(['State'],axis=1)


# to get top 6 rows
start.head(40) # to get top n rows use cars.head(10)

# Correlation matrix 
start.corr()

# we see there exists High collinearity between input variables especially between
# [Hp & SP] , [VOL,WT] so there exists collinearity problem
 
# Scatter plot between the variables along with histograms
import seaborn as sns
sns.pairplot(start)


# columns names
start.columns

# pd.tools.plotting.scatter_matrix(cars); -> also used for plotting all in one graph
                             
# preparing model considering all the variables 
import statsmodels.formula.api as smf # for regression model
         
# Preparing model                  
ml1 = smf.ols('Profit~Rdspend+Administration+marketingspend',data=start).fit() # regression model


# Getting coefficients of variables               
ml1.params

# Summary
ml1.summary()
# p-values for WT,VOL are more than 0.05 and also we know that [WT,VOL] has high correlation value 

# preparing model based only on Volume
ml_v=smf.ols('Profit~marketingspend',data = start).fit()  
ml_v.summary() # 0.271
# p-value <0.05 .. It is significant 

# Preparing model based only on WT
ml_w=smf.ols('Profit~Administration',data = start).fit()  
ml_w.summary() # 0.268

# Preparing model based only on WT & VOL
ml_wv=smf.ols('Profit~marketingspend+Administration',data = start).fit()  
ml_wv.summary() # 0.264
# Both coefficients p-value became insignificant... 
# So there may be a chance of considering only one among VOL & WT

# Checking whether data has any influential values 
# influence index plots

import statsmodels.api as sm
sm.graphics.influence_plot(ml1)
# index 76 AND 78 is showing high influence so we can exclude that entire row

# Studentized Residuals = Residual/standard deviation of residuals

startnew=start.drop(start.index[[45,46,48,49,19,6]],axis=0)

#cars.drop(["MPG"],axis=1)

# X => A B C D 
# X.drop(["A","B"],axis=1) # Dropping columns 
# X.drop(X.index[[5,9,19]],axis=0)

#X.drop(["X1","X2"],aixs=1)
#X.drop(X.index[[0,2,3]],axis=0)


# Preparing model                  
mlnew = smf.ols('Profit~Rdspend+Administration+marketingspend',data = startnew).fit()    

# Getting coefficients of variables        
mlnew.params

# Summary
mlnew.summary() # 0.806

# Confidence values 99%
print(mlnew.conf_int(0.01)) # 99% confidence level


# Predicted values of MPG 
pr_pred = mlnew.predict(startnew[['Rdspend','Administration','marketingspend']])
pr_pred

startnew.head()
# calculating VIF's values of independent variables
rsq_rd = smf.ols('Rdspend~Administration+marketingspend',data=startnew).fit().rsquared  
vif_rd = 1/(1-rsq_rd) # 16.33

rsq_ms = smf.ols('marketingspend~Administration+Rdspend',data=startnew).fit().rsquared  
vif_ms = 1/(1-rsq_ms) # 564.98

rsq_as = smf.ols('Administration~Rdspend+marketingspend',data=startnew).fit().rsquared  
vif_as = 1/(1-rsq_as) #  564.84



           # Storing vif values in a data frame
d1 = {'Variables':['Rdspend','Administration','marketingspend'],'VIF':[vif_rd,vif_ms,vif_as]}
Vif_frame = pd.DataFrame(d1)  
Vif_frame
# As having higher VIF value, we are not going to include this prediction model

# Added varible plot 
sm.graphics.plot_partregress_grid(mlnew)

# added varible plot for weight is not showing any significance 

# final model
final_ml= smf.ols('Profit~Rdspend+marketingspend',data = startnew).fit()
final_ml.params
final_ml.summary() # 0.809
# As we can see that r-squared value has increased from 0.810 to 0.812.

pro_pred = final_ml.predict(startnew)

import statsmodels.api as sm
# added variable plot for the final model
sm.graphics.plot_partregress_grid(final_ml)


######  Linearity #########
# Observed values VS Fitted values
plt.scatter(startnew.Profit,pro_pred,c="r");plt.xlabel("observed_values");plt.ylabel("fitted_values")

# Residuals VS Fitted Values 
plt.scatter(pro_pred,final_ml.resid_pearson,c="r"),plt.axhline(y=0,color='blue');plt.xlabel("fitted_values");plt.ylabel("residuals")


########    Normality plot for residuals ######
# histogram
plt.hist(final_ml.resid_pearson) # Checking the standardized residuals are normally distributed

# QQ plot for residuals 
import pylab          
import scipy.stats as st

# Checking Residuals are normally distributed
st.probplot(final_ml.resid_pearson, dist="norm", plot=pylab)


############ Homoscedasticity #######

# Residuals VS Fitted Values 
plt.scatter(pro_pred,final_ml.resid_pearson,c="r"),plt.axhline(y=0,color='blue');plt.xlabel("fitted_values");plt.ylabel("residuals")



### Splitting the data into train and test data 

from sklearn.model_selection import train_test_split
start_train,start_test  = train_test_split(startnew,test_size = 0.2) # 20% size

# preparing the model on train data 

model_train = smf.ols("Profit~Rdspend+Administration+marketingspend", data=start_train).fit()

# train_data prediction
train_pred = model_train.predict(start_train)

# train residual values 
train_resid  = train_pred - start_train.Profit

# RMSE value for train data 
train_rmse = np.sqrt(np.mean(train_resid*train_resid))

# prediction on test data set 
test_pred = model_train.predict(start_test)

# test residual values 
test_resid  = test_pred - start_test.Profit

# RMSE value for test data 
test_rmse = np.sqrt(np.mean(test_resid*test_resid))
