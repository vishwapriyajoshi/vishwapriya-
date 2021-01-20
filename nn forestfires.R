forestfires <- read.csv("C:/Users/PC/Downloads/forestfires.csv")
View(forestfires)
vj<- forestfires[,c(7:10,31)]
View(vj)
vj$size_category<- ifelse(vj$size_category=="small",0,1)
 normalize<-function(x){
  return ( (x-min(x))/(max(x)-min(x)))
}
vjnorm<-as.data.frame(lapply(vj[,-5],FUN=normalize))
summary(vjnorm)
View(vjnorm)
vjnorm <- cbind(vjnorm,vj$size_category)
colnames(vjnorm)[5] <- "size_category"
vjtrain<-vjnorm[1:400,]
vjtest<-vjnorm[400:517,]
library(neuralnet)  
library(nnet) 
# Building model
vjnn <- paste("size_category",paste(colnames(vj[-5]),collapse ="+"),sep="~")
#vjmodel <- neuralnet(size_category~.,data = vj_train)
vjmodel <- neuralnet(formula = vjnn,data = vjtrain)
str(vjmodel)
plot(vjmodel)
# SSE sum of squared errors . least SSE best model
# Evaluating model performance
# compute function to generate ouput for the model prepared
set.seed(12323)
vjresults <- compute(vjmodel,vjtest[1:5])
str(vjresults)
vjsize <- vjresults$net.result
# predicted_size
# vj_results$neurons
cor(vjsize,vjtest$size_category) 
plot(vjsize,vjtest$size_category)
model_5<-neuralnet(size_category~temp+RH+wind+rain ,data= vjnorm,hidden = 5)
plot(model_5)
model_5_res<-compute(model_5,vjtest[1:5])
pred_vj_5<-model_5_res$net.result
cor(pred_vj_5,vjtest$size_category)
plot(pred_vj_5,vjtest$size_category)
