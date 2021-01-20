bankfull <- read.csv("C:/Users/PC/Downloads/bank-full.csv",header=T,sep=";")
View(bankfull)
summary(bankfull)
head(bankfull, n=5)
colnames(bankfull)

bankfull$ housing<- as.factor(revalue(bankfull$housing,c("yes"=1, "no"=0)))
bankfull$loan <- as.factor(revalue(bankfull$loan,c("yes"=1, "no"=0)))
View(bankfull)
summary(bankfull)

###### build the logistic regression of bankfull data sets its after eveaualting the all the model AIc should be less its an best model#######

model <- glm(y~., data = bankfull, family = "binomial")
summary(model)
 
#####odds ratio########
exp(coef(model))

########confusion matrix table ###########
prob <- predict(model,bankfull,type="response")
prob
confusion<-table(prob>0.5,bankfull$y)
confusion

##########model accuracy ##########
accuracy<- sum(diag(confusion)/sum(confusion))
accuracy

rocrpred<-prediction(prob,bankfull$y)
rocrperf<-performance(rocrpred,'tpr','fpr')

plot(rocrperf,colorize=T,)

