delivery_time <- read_csv("C:/Users/PC/Downloads/delivery_time.csv")
View(delivery_time)
attach(delivery_time)
summary(delivery_time)
plot(delivery_time)
cor(delivery_time)

#####simple linear regression####
rg<-lm(`Sorting Time`~`Delivery Time`)
summary(rg)
pred<-predict(rg)
pred
rg$residuals
sum(rg$residuals)
mean(rg$residuals)
sqrt(sum(rg$residuals^2)/nrow(delivery_time))
sqrt(mean(rg$residuals^2))
confint(rg,level = 0.95)
predict(rg,interval = "predict")


####logerthic model######
regl <- lm(`Sorting Time`~log(`Delivery Time`))
summary(regl)
predict(regl)
regl$residuals
sqrt(sum(regl$residuals^2)/nrow(delivery_time))
sqrt(mean(regl$residuals^2))

