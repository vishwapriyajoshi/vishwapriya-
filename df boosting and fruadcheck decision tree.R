Fraudcheck <- read.csv("C:/Users/PC/Downloads/Fraud_check.csv")
View(Fraudcheck)
summary(Fraudcheck)
attach(Fraudcheck)
colnames(Fraudcheck)
risk<- ifelse(Fraudcheck$Taxable.Income<=30000,'1','0')
Fraudcheck$Urban<- ifelse(Fraudcheck$Urban=='YES',1,0)
Fraudcheck$Undergrad<- ifelse(Fraudcheck$Undergrad=='YES',1,0)
Fraudcheck$Marital.Status<- ifelse(Fraudcheck$Marital.Status=='Single',0, ifelse(Fraudcheck$Marital.Status=='Martial',1,2))
Fraudcheck= data.frame(Fraudcheck,risk)
library(cor)
mean(Fraudcheck$Taxable.Income)
hist(Fraudcheck$Taxable.Income)

library(corpcor)
library(C50)
library(caret)
##########creating data partition############
intrainglocalfm <- createDataPartition(Fraudcheck$risk,p=.75,list=F)
trainingfm <- Fraudcheck[intrainglocalfm,]
testingfm<- Fraudcheck[-intrainglocalfm,]
#########PRAPRING THE DECISION TREE C5.0 risk##########
modelsfm<-C5.0(trainingfm$risk~., data = trainingfm)
summary(modelsfm)
plot(modelsfm)
########## PREPARING THE PREDICTED MODEL FOR TEST DATA######
predfm <- predict.C5.0(modelsfm,testingfm[,-7])
predfm
a<- table(testingfm$risk,predfm)
a
sum(diag(a)/sum(a))
#########creating baginig ######
acc<-c()
for(i in 1:100)
  { 
  print(i)
  inTraininglocal<- createDataPartition(Fraudcheck$risk,p=.85,list = F)
  training1<- Fraudcheck[inTraininglocal,]
  testing1<- Fraudcheck[-inTraininglocal,]
  fittree<- C5.0(training1$risk~.,data = training1)
  pred<- predict.C5.0(fittree,testing1[,-7])
  a<- table(testing1$risk,pred)
  acc<- c(acc,sum(diag(a))/sum(a))
}
summary(acc)        
acc
boxplot(acc)



######### creating boosting models##########3333
models<-C5.0(trainingfm$risk~., data = trainingfm, trails=40)
summary(models)
plot(models)
########## PREPARING THE PREDICTED MODEL FOR TEST DATA######
predf <- predict.C5.0(models,testingfm[,-7])
predf
ab<- table(testingfm$risk,predfm)
ab
sum(diag(ab)/sum(ab))
#####################boosting model###############
accd<-c()
for(i in 1:40)
{ 
  print(i)
  inTraininglocal<- createDataPartition(Fraudcheck$risk,p=.85,list = F)
  training1<- Fraudcheck[inTraininglocal,]
  testing1<- Fraudcheck[-inTraininglocal,]
  fittrees  <- C5.0(training1$risk~.,data = training1,  trails=40)
  preds<- predict.C5.0(fittree,testing1[,-7])
  avg<- table(testing1$risk,preds)
   accd<- c(accd,sum(diag(avg))/sum(avg))
}
summary(accd)        
accd
boxplot(acc)

