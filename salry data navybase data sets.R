SalaryDataTest <- read.csv("C:/Users/Admin/Downloads/SalaryData_Test.csv")
View(SalaryDataTest)
str(SalaryDataTest)
SalaryDataTest$educationno<- as.factor(SalaryDataTest$educationno)
library(e1071)

#####spliting the data sets train and test the data #########3
trainingtest<- SalaryDataTest[1:7030,]
testingtest<- SalaryDataTest[7031:15060,]

#### on the basis of training data sets ####
Model <- naiveBayes(trainingtest$Salary~., data = trainingtest)
Model

Model_pred <- predict(Model,testingtest)
mean(Model_pred==testingtest$Salary)
confusionMatrix(Model_pred,testingtest$Salary).


######## on the basis of all the data sets ########
model1<- naiveBayes(SalaryDataTest$Salary~., data = SalaryDataTest)
model1

Model_pred1 <- predict(model1,SalaryDataTest)
mean(Model_pred1==SalaryDataTest$Salary)
confusionMatrix(Model_pred1,SalaryDataTest$Salary)



ggplot(data=trainingtest,aes(x = trainingtest$age, fill = trainingtest$Salary)) +
  geom_density( color = 'black')
