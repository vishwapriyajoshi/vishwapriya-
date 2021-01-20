forestfires <- read.csv("C:/Users/PC/Downloads/forestfires.csv")
View(forestfires)
columnames(vj)
colnames(vj)
row.names(month)
vj<- forestfires[,c(7:11,31)]
View(vj)
str(forestfires)
summary(forestfires)

normalise <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

forestfires$temp <- normalise(forestfires$temp)
forestfires$rain <- normalise(forestfires$rain)
forestfires$RH <- normalise(forestfires$RH)
forestfires$wind <- normalise(forestfires$wind)


forertrain<-forestfires[1:400,]
forertest<- forestfires[401:517,]


 
library(e1071)
library(kernlab)



####preparing the model svm vanillodot###########
model1<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "vanilladot")
model1
pred1 <-predict(model1,newdata=forertest)     
mean(pred1==forertest$size_category)
pred1


model2<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "rbfdot")
model2
pred2 <-predict(model2,newdata=forertest)     
mean(pred2==forertest$size_category)
pred2


model3<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "polydot",C = 1)
model3
pred3 <-predict(model3,newdata=forertest)     
mean(pred3==forertest$size_category)
pred3


model4<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "tanhdot")
model4
pred4 <-predict(model4,newdata=forertest)     
 mean(pred4==forertest$size_category)
pred4

laplacedot
model5<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "laplacedot")
model5
pred5 <-predict(model5,newdata=forertest)     
mean(pred5==forertest$size_category)
pred5


besseldot
model6<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "besseldot")
model6
pred6<-predict(model6,newdata=forertest)     
mean(pred6==forertest$size_category)
pred6


model7<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "anovadot")
model7
pred7 <-predict(model7,newdata=forertest)     
mean(pred7==forertest$size_category)
pred7

splinedot
model8<-ksvm(size_category~temp+RH+wind+rain, data = forertrain,  kernel = "splinedot")
model8
pred8<-predict(model8,newdata=forertest)     
mean(pred8==forertest$size_category)
pred8




library(ggplot2)
ggplot(data=forestfires,aes(x=forestfires$size_category, y = forestfires$temp, fill = forestfires$size_category)) +
  geom_boxplot() +
  ggtitle("Box Plot")

boxplot(forestfires$size_category,forestfires$temp)
hist(forestfires$temp)
boxplot(forestfires$temp)
