Zoo <- read.csv("C:/Users/Admin/Downloads/Zoo.csv")
View(Zoo)
str(Zoo)
Zoo<- Zoo[-1]
View(Zoo)
vj<- scale(Zoo[,1:16])
View(vj)
Zoo <- cbind(vj,Zoo[17])
View(Zoo)



#######spliting the data train and test ################
datatrain<- Zoo[1:78,]
datatest<- Zoo[79:101,]

######## getting label train and test data ##########3
datatrainlabel<- Zoo[1:78,17]
datatestlabel<- Zoo[79:101,17]

######### using the method of knn in loop  #############3

library(class)
test_acc <- NULL
train_acc <- NULL
for (i in seq(3,50,2))
{
  trainzoo_pred <- knn(train=datatrain,test=datatrain,cl=datatrainlabel,k=i)
  train_acc <- c(train_acc,mean(trainzoo_pred==datatrainlabel))
  testzoog_pred <- knn(train = datatrain, test = datatest, cl = datatrainlabel, k=i)
  test_acc <- c(test_acc,mean(testzoog_pred==datatestlabel))
}

plot(seq(3,50,2),train_acc,type="l",main="Train_accuracy",col="blue")
plot(seq(3,50,2),test_acc,type="l",main="Test_accuracy",col="red")


acc_knn_df <- data.frame(list(train_acc=train_acc,test_acc=test_acc,kncs=seq(3,50,2)))


