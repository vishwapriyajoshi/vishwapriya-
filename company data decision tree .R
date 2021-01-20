CompanyData <- read.csv("C:/Users/PC/Downloads/Company_Data.csv")
View(CompanyData)
library(caret)
library(C50)


CompanyData$Urban<- ifelse(CompanyData$Urban =="YES",0,1)
CompanyData<- data.frame(CompanyData,CompanyData$Urban)
View(CompanyData)


help(atomic vector)



######PREAPRING THE TRANING AND TESTING THE shelveloc MODELS#############
intrainglocal <- createDataPartition(CompanyData$ShelveLoc,p=.75,list=F)
training <- CompanyData[intrainglocal,]
testing<- CompanyData[-intrainglocal,]
#########PRAPRING THE DECISION TREE C5.0 shelveloc##########
models<-C5.0(training$ShelveLoc~., data = training)
summary(models)
plot(models)
########## PREPARING THE PREDICTED MODEL FOR TEST DATA######
pred <- predict.C5.0(models,testing[,-7])
pred
accuracy<- table(testing$ShelveLoc, pred)
accuracy

sum(diag(accuracy)/sum(accuracy))
plot(models)



###############create data partiation of urban train and test data  #############
intrainglocalg <- createDataPartition(CompanyData$Urban,p=.75,list=F)
trainingu <- CompanyData[intrainglocalg,]
testingu<- CompanyData[-intrainglocalg,]
##########create the model urban ##########
modelu<-C5.0(trainingu$Urban~., data = trainingu)
summary(modelu)
plot(modelu)
############ predicted model of c5.0 alogorithms test data #######
pred <- predict.C5.0(modelu,testingu[,-5])
pred
accuracy<- table(testingu$Urban,pred)
accuracy

sum(diag(accuracy)/sum(accuracy))
plot(modelu)







