####### all pakages to run the codes ###########
library(C50)
library(caret)
library(e1071)
library(kernlab)
library(e1071)
library(caret)
library(naivebayes)
library(ggplot2)
library(randomForest)
library(gmodels)


############ spliting data into train and test##########
as <- read.csv("C:/Users/smeeta/Downloads/prjs.csv")
View(as)
va<-data.frame(lapply(as,as.factor))
ms<- va[,2:10]
sjsj<- createDataPartition(ms$amazon,p=.75,list=F)
train<- ms[sjsj,]
test<- ms[-sjsj,]

####preparing the model svm with consider the train data  kernal is vanillodot###########
model1<-ksvm(amazon ~.,data = train,kernel = "vanilladot")
model1
pred1 <-predict(model1,newdata=test)
svmaccuracy<-mean(pred1==test$amazon)
pred1
####preparing the model svm rbfdot###########
model2<-ksvm(amazon ~.,data = train, kernel = "rbfdot")
pred12<-predict(model2,newdata=test)
mean(pred12==test$amazon) 
pred12
model2
####preparing the model svm polydot###########
model3<-ksvm(amazon~.,data = train,kernel = "polydot")
pred13<-predict(model3,newdata=test)
mean(pred13==test$amazon)
pred13
model3
####preparing the model svm besselodot###########
model4<-ksvm(train$android ~.,data = train,kernel = "besseldot")
pred14<-predict(model4,newdata=test)
mean(pred14==test$android) 
pred14
model4


##########navybase pakage e1071##########
model<-naiveBayes(amazon~.,data=train)
pred<-predict(model,newdata = train)
navye1071accuracy<- mean(pred==train$amazon)#train data accuracy=0.9
mean(pred==test$amazon) # testdataAccuracy = 0.9 % 
# Confusion Matrix
confusionMatrix(train$amazon, pred)
CrossTable(train$amazon,pred)
ggplot(data = train ,aes(x = train$amazon , y = train$around, fill = train$also))+
  geom_boxplot()+
  ggtitle("BOXPLOT")

######### navybase model building pakage is naievybase###############
model <- naive_bayes(train$amazon~.,data=train)
model
model_pred <- predict(model,test)
navybaseaccuracyorg<- mean(model_pred == test$amazon)   #60%
#CONFUSIONMATRIX
confusionMatrix(test$amazon, model_pred)

################# random forest model####################
fit.forest <- randomForest(amazon~.,data=train,importance=TRUE)
# Training accuracy 
randomaccurcy<- mean(train$amazon==predict(fit.forest,train)) # 100% accuracy 
# Prediction of train data
pred_train <- predict(fit.forest,train)
# Confusion Matrix
confusionMatrix(train$amazon, pred_train)
# Predicting test data 
pred_test <- predict(fit.forest,newdata=test)
mean(pred_test==test$amazon) # Accuracy = 94.6 % 
# Confusion Matrix 
confusionMatrix(test$amazon, pred_test)
# Visualization 
plot(fit.forest,lwd=2)
legend("topright", colnames(fit.forest$err.rate),col=1:15,cex=0.8,fill = 1:15)


######## decision tree ##############
prc5.0_train <- C5.0(train[,-2],train$amazon)
windows()
plot(prc5.0_train) # Tree graph
# Training accuracy
predtrain <- predict(prc5.0_train,train)
decisionaccuracy<- mean(train$amazon==predtrain) # 0.9% Accuracy
confusionMatrix(predtrain,train$amazon)##confusion matric for train data 
predc5.0_test <- predict(prc5.0_train,newdata=test) # predicting on test data
mean(predc5.0_test==test$amazon) # 0.9 testaccuracy 
confusionMatrix(predc5.0_test,test$amazon)
# Cross tables
CrossTable(test$amazon,predc5.0_test)
################ all acccuracy data make data.frame easy to find out which is best ##########
accuracy <- data.frame(decisionaccuracy,randomaccurcy,navybaseaccuracyorg,navye1071accuracy,svmaccuracy)
