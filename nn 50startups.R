Startups <- read.csv("C:/Users/PC/Downloads/50_Startups.csv")
View(Startups)
Startups$State<- ifelse(Startups$State=="New York",1, ifelse(Startups$State=="Florida",0,2))
str(Startups)
Startups<- as.data.frame(Startups)
attach(Startups)
cor(Startups)
pairs(Startups)
###########NORMAlising the data sets#########
normalize<-function(x){
  return ( (x-min(x))/(max(x)-min(x)))
}
Startupsnorm<-as.data.frame(lapply(Startups,FUN=normalize))
summary(Startupsnorm$Profit)  
library(caret)
####### creating the data partition train and test the data###########
intrainglocal <- createDataPartition(Startupsnorm$Profit,p=.85,list=F)
training <- Startupsnorm[intrainglocal,]
testing<- Startupsnorm[-intrainglocal,]
library(neuralnet)  
library(nnet) 
formula <- paste("Profit",paste(colnames(Startupsnorm),collapse ="+"),sep="~")
###########creating the model  nural net ########
stamodel<- neuralnet(formula =formula,data = training)
str(stamodel)
plot(stamodel)

###########SSE sum of squared errors . least SSE best model
# Evaluating model performance
# compute function to generate ouput for the model prepared
set.seed(12323)
model_results <- compute(stamodel,testing[1:5])
str(model_results)
predicted_sta <- model_results$net.result
# predicted
# model_results$neurons
cor(predicted_sta,testing$Profit)
plot(predicted_sta,testing$Profit)
model_5<-neuralnet(Profit~Marketing.Spend+State+R.D.Spend+Administration,data=Startupsnorm,hidden = 3)
plot(model_5)
model_5_res<-compute(model_5,testing[1:5])
pred_strn_5<-model_5_res$net.result
cor(pred_strn_5,testing$Profit)
plot(pred_strn_5,testing$Profit)
# SSE has reduced and training steps had been increased as the number of nuerons 
# under hidden layer are increased



