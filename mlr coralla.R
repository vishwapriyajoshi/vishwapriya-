vjvjcr2 <- read.csv("C://Users//PC//Downloads//vjvjcr2.csv")
View(vjvjcr2)
summary(vjvjcr2)
cor(vjvjcr2)
var(vjvjcr2)
cor2pcor(cor(vjvjcr2))
pairs(vjvjcr2)
plots(vjvjcr2) 



####the mlineaer model all #####
regc <- lm(Price~., data = vjvjcr2)
summary(regc) 
vif(regc)
plot() 
#####the mlm model  price and cc####
regcc <- lm(Price~cc, data = vjvjcr2)
summary(regcc)

###### the mlm model price and doors ####
regdo <- lm(Price~Doors,data = vjvjcr2)
summary(regdo)

##### multi lm model price  Doors and cc######
cmodel <- lm(Price~Doors+cc, data = vjvjcr2 )
summary(cmodel)
influence.measures(cmodel)
influencePlot(cmodel)

#### deleting influence 81 coloum build the model######
model1 <- lm(Price ~ ., data =vjvjcr2[-c(81),])
summary(model1)
vif(model1)
avPlots(model1)

##### final model############
finalmodel <- lm(Price ~ Age_08_04 + KM + HP + cc + Gears + Quarterly_Tax + Weight, data = vjvjcr2[-c(81),])
summary(finalmodel)
plot(finalmodel)


