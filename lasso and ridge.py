import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import Ridge
from sklearn.linear_model import Lasso
from sklearn.linear_model import ElasticNet
from sklearn.neighbors import KNeighborsRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.svm import SVR
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score
from sklearn.model_selection import train_test_split
import matplotlib.pylab as plt
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt

# reading a csv file using pandas library
salary=pd.read_csv("C:/Users/user/Downloads/Salary_data.csv")
salary.columns
plt.hist(salary.Salary)
plt.boxplot(salary.Salary,0,"rs",0)
plt.hist(salary.YearsExperience)
plt.boxplot(salary.YearsExperience)
plt.plot(salary.YearsExperience,salary.Salary,"bo");plt.xlabel("YearsExperience");plt.ylabel("salary")
salary.YearsExperience.corr(salary.Salary) # # correlation value between X and Y
np.corrcoef(salary.YearsExperience,salary.Salary)


model=smf.ols("YearsExperience~Salary",data=salary).fit()
# For getting coefficients of the varibles used in equation
model.params
# P-values for the variables and R-squared value for prepared model
model.summary() 
model.conf_int(0.05) # 95% confidence interval 
pred = model.predict(salary) # Predicted values of AT using the 

# For visualization we need to import matplotlib.pyplot 

plt.scatter(x=salary['Salary'],y=salary['YearsExperience'],color='red');plt.plot(salary['Salary'],pred,color='black');plt.xlabel('Salary');plt.ylabel('YearsExprience')
pred.corr(salary.YearsExperience) # 0.


# Transforming variables for accuracy
model2 = smf.ols('YearsExperience~np.log(Salary)',data=salary).fit()
model2.params
model2.summary()
print(model2.conf_int(0.01)) # 99% confidence level
pred2 = model2.predict(pd.DataFrame(salary['Salary']))
pred2.corr(salary.YearsExperience)
# pred2 = model2.predict(wcat.iloc[:,0])
pred2
plt.scatter(x=salary['Salary'],y=salary['YearsExperience'],color='green');plt.plot(salary['Salary'],pred2,color='blue');plt.xlabel('Salary');plt.ylabel('years')

# Exponential transformation
model3 = smf.ols('np.log(YearsExperience)~Salary',data=salary).fit()
model3.params
model3.summary()
print(model3.conf_int(0.01)) # 99% confidence level
pred_log = model3.predict(pd.DataFrame(salary['Salary']))
pred_log
pred3=np.exp(pred_log)  # as we have used log(Yearsexperiecnce) in preparing model so we need to convert it back
pred3
pred3.corr(salary.YearsExperience)
plt.scatter(x=salary['Salary'],y=salary['YearsExperience'],color='green');plt.plot(salary.Salary,np.exp(pred_log),color='blue');plt.xlabel('Salary');plt.ylabel('yearsexperience')
resid_3 = pred3-salary.YearsExperience
student_resid = model3.resid_pearson 
student_resid
plt.plot(model3.resid_pearson,'o');plt.axhline(y=0,color='green');plt.xlabel("Observation Number");plt.ylabel("Standardized Residual")
# Predicted vs actual values
plt.scatter(x=pred3,y=salary.YearsExperience);plt.xlabel("Predicted");plt.ylabel("Actual")


# Quadratic model
salary["Salary_Sq"] = salary.Salary*salary.Salary
model_quad = smf.ols("YearsExperience~Salary+Salary_Sq",data=salary).fit()
model_quad.params
model_quad.summary()
pred_quad = model_quad.predict(salary.Salary)
model_quad.conf_int(0.05)  
pred_quad = model_quad.predict(salary.Salary)
plt.scatter(salary.Salary,salary.YearsExperience,c="b");plt.plot(salary.Salary,pred_quad,"r")
plt.scatter(np.arange(109),model_quad.resid_pearson);plt.axhline(y=0,color='red');plt.xlabel("Observation Number");plt.ylabel("Standardized Residual")
plt.hist(model_quad.resid_pearson) # histogram for residual values 

############################### Implementing the Linear Regression model from sklearn library

plt.scatter(salary.Salary,salary.YearsExperience)
model1 = LinearRegression()
model1.fit(salary.Salary.values.reshape(-1,1),salary.YearsExperience)
pred1 = model1.predict(salary.Salary.values.reshape(-1,1))
# Adjusted R-Squared value
model1.score(salary.Salary.values.reshape(-1,1),salary.YearsExperience)# 0.6700
rmse1 = np.sqrt(np.mean((pred1-salary.YearsExperience)**2)) # 32.760
model1.coef_
model1.intercept_

#### Residuals Vs Fitted values

plt.scatter(pred1,(pred1-salary.YearsExperience),c="r")
plt.hlines(y=0,xmin=0,xmax=300) 
# checking normal distribution for residual
plt.hist(pred1-salary.YearsExperience)

### Fitting Quadratic Regression 
salary["Salary_sqrd"] = salary.Salary*salary.Salary
model2 = LinearRegression()
model2.fit(X = salary.iloc[:,[0,2]],y=salary.YearsExperience)
pred2 = model2.predict(salary.iloc[:,[0,2]])
# Adjusted R-Squared value
model2.score(salary.iloc[:,[0,2]],salary.YearsExperience)# 0.67791
rmse2 = np.sqrt(np.mean((pred2-salary.YearsExperience)**2)) # 32.366
model2.coef_
model2.intercept_

#### Residuals Vs Fitted values
plt.scatter(pred2,(pred2-salary.YearsExperience),c="r")
plt.hlines(y=0,xmin=0,xmax=200)  
# Checking normal distribution
plt.hist(pred2-salary.YearsExperience)
import pylab
import scipy.stats as st
st.probplot(pred2-salary.YearsExperience,dist="norm",plot=pylab)

# Let us prepare a model by applying transformation on dependent variable
salary["YearsExperience_sqrt"] = np.sqrt(salary.YearsExperience)
model3 = LinearRegression()
model3.fit(X = salary.iloc[:,[0,2]],y=salary.YearsExperience_sqrt)
pred3 = model3.predict(salary.iloc[:,[0,2]])
# Adjusted R-Squared value
model3.score(salary.iloc[:,[0,2]],salary.YearsExperience_sqrt)# 0.98
rmse3 = np.sqrt(np.mean(((pred3)**2-salary.YearsExperience)**2)) # 32.76
model3.coef_
model3.intercept_

#### Residuals Vs Fitted values
plt.scatter((pred3)**2,((pred3)**2-salary.YearsExperience),c="r")
plt.hlines(y=0,xmin=0,xmax=300)  
# checking normal distribution for residuals 
plt.hist((pred3)**2-salary.YearsExperience)
st.probplot((pred3)**2-salary.YearsExperience,dist="norm",plot=pylab)

# Let us prepare a model by applying transformation on dependent variable without transformation on input variables 
model4 = LinearRegression()
model4.fit(X = salary.Salary.values.reshape(-1,1),y=salary.YearsExperience_sqrt)
pred4 = model4.predict(salary.Salary.values.reshape(-1,1))
# Adjusted R-Squared value
model4.score(salary.Salary.values.reshape(-1,1),salary.YearsExperience_sqrt)# 0.7096
rmse4 = np.sqrt(np.mean(((pred4)**2-salary.YearsExperience)**2)) # 34.165
model4.coef_
model4.intercept_

#### Residuals Vs Fitted values
plt.scatter((pred4)**2,((pred4)**2-salary.YearsExperience),c="r")
plt.hlines(y=0,xmin=0,xmax=300)  
st.probplot((pred4)**2-salary.YearsExperience,dist="norm",plot=pylab)
# Checking normal distribution for residuals 
plt.hist((pred4)**2-salary.YearsExperience)

# import ridge regression from sklearn library 
from sklearn.linear_model import Ridge 

target_column = ['YearsExperience'] 
predictors = list(set(list(salary.columns))-set(target_column))
salary[predictors] = salary[predictors]/salary[predictors].max()
salary.describe()

X = salary[predictors].values
y = salary[target_column].values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.30, random_state=40)
print(X_train.shape); print(X_test.shape)

lr = LinearRegression()
lr.fit(X_train, y_train)
LinearRegression(copy_X=True, fit_intercept=True, n_jobs=1, normalize=False)
pred_train_lr= lr.predict(X_train)
print(r2_score(y_train, pred_train_lr))
pred_test_lr= lr.predict(X_test)
print(r2_score(y_test, pred_test_lr))

#linear ridge regression 
rr = Ridge(alpha=0.01)
rr.fit(X_train, y_train) 
pred_train_rr= rr.predict(X_train)
print(r2_score(y_train, pred_train_rr))
pred_test_rr= rr.predict(X_test)
print(r2_score(y_test, pred_test_rr))


#linear lasso regression 
model_lasso = Lasso(alpha=0.01)
model_lasso.fit(X_train, y_train) 
pred_train_lasso= model_lasso.predict(X_train)
print(r2_score(y_train, pred_train_lasso))
pred_test_lasso= model_lasso.predict(X_test)
print(r2_score(y_test, pred_test_lasso))
