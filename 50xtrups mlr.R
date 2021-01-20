Xtartups  <- read.csv("C://Users//PC//Downloads//50_Startups.csv")
View(Xtartups)
summary(Xtartups)
pairs(Xtartups)
Xtartups[4]<-NULL
View(Xtartups)
attach(Xtartups)
cor(Xtartups)
cor2pcor(cor(Xtartups))


model<- lm(Profit~., data = Xtartups)
summary(model)
pairs(Xtartups)
plot(model)

window(model)
influence.measures(model)
influenceindexplot(model)
influenc