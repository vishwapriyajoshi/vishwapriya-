SalaryDataTrain <- read.csv("C:/Users/Admin/Downloads/SalaryData_Train.csv")
View(SalaryDataTrain)
str(SalaryDataTrain)
SalaryDataTrain$educationno<- as.factor(SalaryDataTrain$educationno)
library(e1071)
library(caret)
#####spliting the data sets train and test the data #########3
trainingtrain<- SalaryDataTrain[1:7030,]
testingtrain<- SalaryDataTrain[7031:15060,]

#### on the basis of trainingtrian data sets ####
Model <- naiveBayes(trainingtrain$Salary~., data = trainingtrain)
Model

Model_pred <- predict(Model,testingtrain)
mean(Model_pred==testingtrain$Salary)
confusionMatrix(Model_pred,testingtrain$Salary)


######## on the basis of all the data sets ########
model1<- naiveBayes(SalaryDataTrain$Salary~., data = SalaryDataTrain)
model1

Model_pred1 <- predict(model1,SalaryDataTrain)
mean(Model_pred1==SalaryDataTrain$Salary)
confusionMatrix(Model_pred1,SalaryDataTrain$Salary)

ggplot(data=trainingtrain,aes(x = trainingtrain$age, fill = trainingtrain$Salary)) +
  geom_density( color = 'black')


ggplot(data=SalaryDataTrain,aes(x = SalaryDataTrain$workclass, fill = SalaryDataTrain$Salary)) +
  geom_density( color = 'Violet')







