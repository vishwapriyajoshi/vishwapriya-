
glass <- read.csv("C:/Users/Admin/Downloads/glass.csv")
View(glass)
vj<- scale(glass[,1:9])
View(vj)
data <- cbind(vj,glass[10])
View(data)
library(corrplot)
corrplot(cor(data))
####spliting the data train and test #######
datatrain<- data[1:150,]
datatest<- data[151:214,]

#########get labels ##########
datatrainlabel<- glass[1:150,10]
datatestlabel<- glass[151:214,10]



test_acc <- NULL
train_acc <- NULL
for (i in seq(3,50,2))
{
  trainglass_pred <- knn(train=datatrain,test=datatrain,cl=datatrainlabel,k=i)
  train_acc <- c(train_acc,mean(trainglass_pred==datatrainlabel))
  testglass_pred <- knn(train = datatrain, test = datatest, cl = datatrainlabel, k=i)
  test_acc <- c(test_acc,mean(testglass_pred==datatestlabel))
}

plot(seq(3,50,2),train_acc, type="l",main="Train_accuracy", col="blue")
plot(seq(3,50,2),test_acc, type="l",main="Test_accuracy", col="red")


acc_knn_df <- data.frame(list(train_acc=train_acc,test_acc=test_acc,kncs=seq(3,50,2)))
