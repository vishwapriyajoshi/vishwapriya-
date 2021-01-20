affairst <- read.csv("C:/Users/PC/Downloads/affairs.csv")
View(affairst)
summary(affairst)
attach(affairst)

affairst$affairs[affairst$affairs > 0] <- 1
affairst$affairs[affairst$affairs == 0] <- 0
affairst$gender <- as.factor(revalue(affairst$gender,c("male"=2, "female"=1)))
affairst$children <- as.factor(revalue(affairst$children,c("yes"=1, "no"=0)))
View(affairst)

################## preparing the linear model with all avarible #################
modl <- lm(affairs ~ gender + age+ yearsmarried+ children + religiousness+
               education+occupation+rating, data = affairst)
summary(modl)

##########prediction of lm model#################
preds <- predict(modl,affairst)
preds
plot(preds)


############# build the model of logistic model########## 

modela <- glm(affairs ~ factor(gender) + age+ yearsmarried+ factor(children) + religiousness+
               education+occupation+rating, data = affairst,family = "binomial")

summary(modela)


############# build the model of logistic model neglating the age and rating ########## 
modelra <- glm(affairs ~ factor(gender) +  yearsmarried+ factor(children) + religiousness+
               education+occupation, data = affairst,family = "binomial")

summary(modelra)



############# build the model of logistic model  y target varible has be changed ########## 

modelg <- glm( factor(gender)~ age+ yearsmarried+ factor(children) +
               education+occupation, data = affairst,family = "binomial")

summary(modelg)

######################## modela is better compare the other model because AIC is less then other model i choose the model of modela#################

############odds ratio#########
exp(coef(modela))

###############confusion matrix table############
prob <- predict(modela,affairst,type="response")
prob
confusion<-table(prob>0.5,affairst$affairs)
confusion


########model accuracy########
vjvjaccuracy<- sum(diag(confusion)/sum(confusion))
vjvjaccuracy

library(ROCR)
rocrpred<-prediction(prob,affairst$affairs)
rocrperf<-performance(rocrpred,'tpr','fpr')

plot(rocrperf,colorize=T,)

plot.default(confusion)
