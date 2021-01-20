SalaryDataTest1 <- read.csv("C:/Users/PC/Downloads/SalaryData_Test(1).csv")
View(SalaryDataTest1)
summary(SalaryDataTest1)
colnames(SalaryDataTest1)<-c("age","workclass","education","educationno","maritalstatus","occupation","relationship","race","sex","capitalgain","capitalloss","hoursperweek","native","salary")
View(SalaryDataTest1)
library()
library(e1071)
library(kernlab)
salarytrain<- SalaryDataTest1[1:7000,]
salarytest<- SalaryDataTest1[7001:15060,]



####preparing the model svm vanillodot###########
model1<-ksvm(salary ~.,data = salarytrain,kernel = "vanilladot")
model1
pred1 <-predict(model1,newdata=salarytest)
mean(pred1==salarytest$salary)
pred1

####preparing the model svm rbfdot###########
model2<-ksvm(salary ~.,data = salarytrain, kernel = "rbfdot")
pred12<-predict(model2,newdata=salarytest)
mean(pred12==salarytest$salary) 
pred12
model2

####preparing the model svm polydot###########
model3<-ksvm(salary ~.,data = salarytrain,kernel = "polydot")
pred13<-predict(model3,newdata=salarytest)
mean(pred13==salarytest$salary)
pred13
model3


####preparing the model svm tanhdot###########
model4<-ksvm(salary ~.,data = salarytrain,kernel = "tanhdot")
pred14<-predict(model4,newdata=salarytest)
mean(pred14==salarytest$salary) 
pred14
model4
####preparing the model svm laplacedot###########
model5<-ksvm(salary ~.,data = salarytrain,kernel = "laplacedot")
pred15<-predict(model5,newdata=salarytest)
mean(pred15==salarytest$salary) 
pred15
model5
####preparing the model svm besselodot###########
model6<-ksvm(salary ~.,data = salarytrain,kernel = "besseldot")
pred16<-predict(model6,newdata=salarytest)
mean(pred16==salarytest$salary) 
pred16
model6

####preparing the model svm anovadot###########
model7<-ksvm(salary ~.,data = salarytrain,kernel = "anovadot")
pred17<-predict(model7,newdata=salarytest)
mean(pred17==salarytest$salary) 
pred17
model7

####preparing the model svm splinedot###########
model8<-ksvm(salary ~.,data = salarytrain,kernel = "splinedot")
pred18<-predict(model8,newdata=salarytest)
mean(pred18==salarytest$salary) 
pred18
model8


####preparing the model svm matrix###########
model9<-ksvm(salary ~.,data = salarytrain,kernel = "matrix")
pred19<-predict(model9,newdata=salarytest)
mean(pred19==salarytest$salary) 
pred19
model9


library(ggplot2)
ggplot(data=SalaryDataTest1,aes(x=SalaryDataTest1$salary, y = SalaryDataTest1$hoursperweek, fill = SalaryDataTest1$Salary)) +
  geom_boxplot() +
  ggtitle("Box Plot")

