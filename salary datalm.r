Salary_Data <- read_csv("C:/Users/PC/Downloads/Salary_Data.csv")
View(Salary_Data)
attach(Salary_Data)
summary((Salary_Data)
plot((Salary_Data)
cor((Salary_Data)

#####simple linear regression#####
reg <- lm(YearsExperience~Salary)
summary(reg)
pred <-predict(reg)
pred
reg$residuals
sum(reg$residuals)
mean(reg$residuals)
sqrt(sum(reg$residuals^2)/nrow(Salary_Data))
sqrt(mean(reg$residuals^2))
confint(reg,level = 0.95)
predict(reg,interval = "predict")


####logerthic model using the lm######
regl <- lm(YearsExperience~log(Salary))
summary(regl)
predict(regl)
regl$residuals
sqrt(sum(regl$residuals^2)/nrow(Salary_Data))
sqrt(mean(regl$residuals^2))
plot(regl)

#######expontial model using the lm#######

reg_exp <- lm(log(YearsExperience) ~ Salary)  #lm(log(Y) ~ X)
summary(reg_exp)
reg_exp$residuals
sqrt(mean(reg_exp$residuals^2))
logat <- predict(reg_exp)
summary(logat)
at <- exp(logat)
summary(at)
error = Salary_Data$YearsExperience - Salary
error
sqrt(sum(error^2)/nrow(Salary_Data))  #RMSE
confint(reg_exp,level=0.95)
predict(reg_exp,interval="confidence")

