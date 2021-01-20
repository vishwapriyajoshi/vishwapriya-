ComputerData <- read.csv("C:/Users/PC/Downloads/Computer_Data.csv")
View(Computer_Data)
summary(Computer_Data)
cor(ComputerData)
ComputerData <- ComputerData[,-1]
data <- ComputerData
attach(ComputerData)
View(ComputerData)
summary(ComputerData)
pairs(ComputerData)
pairs.panels(ComputerData)

###### creating the multi linear regression #############
reg <- lm(price ~., data= ComputerData)
summary(reg)
influence.measures(reg)
influencePlot(reg)
vif(reg)
plot(reg)

########### mlr is influence the 2 colums 1441, 1701 #######
model1 <- lm(price ~ ., data = ComputerData[-c(1441, 1701),])
summary(model1)

########### mlr is influence the 4 col 1441, 1701,3784,4478 #######
model2 <- lm(price ~ ., data = ComputerData[-c(1441, 1701,3784,4478),])
summary(model2)
vif(model2)
avPlots(model2)


########### mlr is influence the 2 colums with selected rows only  1441, 1701 #######
model3 <- lm(price ~ speed + hd + ram + screen + ads + trend + premium, data = ComputerData[-c(1441, 1701),])
summary(model3)
avPlots(model3)

########### mlr is influence the 4 col with selected rows 1441, 1701,3784,4478 #######
model4 <- lm(price ~ speed + hd + ram + screen + ads + trend + premium, data = ComputerData[-c(1441, 1701,3784,4478),])
summary(model4)
avPlots(model4)
