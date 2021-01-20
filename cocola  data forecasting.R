CocaCola<- read_excel("C:/Users/Admin/Downloads/CocaCola_Sales_Rawdata (1).xlsx")
View(CocaCola)

Q1 <-  ifelse(grepl("Q1",CocaCola$Quarter),'1','0')
Q2 <-  ifelse(grepl("Q2",CocaCola$Quarter),'1','0')
Q3 <-  ifelse(grepl("Q3",CocaCola$Quarter),'1','0')
Q4 <-  ifelse(grepl("Q4",CocaCola$Quarter),'1','0')

CocacolaData<-cbind(CocaCola,Q1,Q2,Q3,Q4)
View(CocacolaData)
CocacolaData["t"]<- 1:42
View(CocacolaData)
CocacolaData["log_Sales"]<-log(CocacolaData["Sales"])
CocacolaData["t_square"]<-CocacolaData["t"]*CocacolaData["t"]
attach(CocacolaData)
train<- CocacolaData[1:36,]
test<- CocacolaData[37:42,]

##########LINIER model ##############
lm_model <- lm(Sales~t, data = train)
summary(lm_model)
linearpred<-data.frame(predict(lm_model,interval='predict',newdata =test))
View(linearpred)
rmse_linear<-sqrt(mean((test$Sales-linearpred$fit)^2,na.rm = T))
rmse_linear




######################### Exponential #################################

expomodel<-lm(log_Sales~t,data=train)
summary(expomodel)
expo_pred<-data.frame(predict(expomodel,interval='predict',newdata=test))
rmse_expo<-sqrt(mean((test$Sales-exp(expo_pred$fit))^2,na.rm = T))
rmse_expo # 46

######################### Quadratic ####################################

Quad_model<-lm(Sales~t+t_square, data=train)
summary(Quad_model)
Quad_pred<-data.frame(predict(Quad_model,interval='predict',newdata=test))
rmse_Quad<-sqrt(mean((test$Sales-Quad_pred$fit)^2,na.rm=T))
rmse_Quad # 48.05189

######################### Additive Seasonality #########################

sea_add_model<-lm(Sales~Q1+Q2+Q3+Q4,data=train)
summary(sea_add_model)
sea_add_pred<-data.frame(predict(sea_add_model,newdata=test,interval='predict'))
rmse_sea_add<-sqrt(mean((test$Sales-sea_add_pred$fit)^2,na.rm = T))
rmse_sea_add

######################## Additive Seasonality with Linear #################

Add_sea_Linear_model<-lm(Sales~t+Q1+Q2+Q3+Q4,data=train)
summary(Add_sea_Linear_model)
Add_sea_Linear_pred<-data.frame(predict(Add_sea_Linear_model,interval='predict',newdata=test))
rmse_Add_sea_Linear<-sqrt(mean((test$Sales-Add_sea_Linear_pred$fit)^2,na.rm=T))
rmse_Add_sea_Linear # 35.34

######################## Additive Seasonality with Quadratic #################

Add_sea_Quad_model<-lm(Sales~t+t_square+Q1+Q2+Q3+Q4,data=train)
summary(Add_sea_Quad_model)
Add_sea_Quad_pred<-data.frame(predict(Add_sea_Quad_model,interval='predict',newdata=test))
rmse_Add_sea_Quad<-sqrt(mean((test$Sales-Add_sea_Quad_pred$fit)^2,na.rm=T))
rmse_Add_sea_Quad # 26

######################## Multiplicative Seasonality #########################

multi_sea_model<-lm(log_Sales~Q1+Q2+Q3+Q4,data = train)
summary(multi_sea_model)
multi_sea_pred<-data.frame(predict(multi_sea_model,newdata=test,interval='predict'))
rmse_multi_sea<-sqrt(mean((test$Sales-exp(multi_sea_pred$fit))^2,na.rm = T))
rmse_multi_sea # 140.00632

######################## Multiplicative Seasonality Linear trend ##########################

multi_add_sea_model<-lm(log_Sales~t+Q1+Q2+Q3+Q4,data = train)
summary(multi_add_sea_model) 
multi_add_sea_pred<-data.frame(predict(multi_add_sea_model,newdata=test,interval='predict'))
rmse_multi_add_sea<-sqrt(mean((test$Sales-exp(multi_add_sea_pred$fit))^2,na.rm = T))
rmse_multi_add_sea # 10.51

# Preparing table on model and it's RMSE values 

tablermse<-data.frame(c("rmse_linear","rmse_expo","rmse_Quad","rmse_sea_add","rmse_Add_sea_Quad","rmse_multi_sea","rmse_multi_add_sea"),c(rmse_linear,rmse_expo,rmse_Quad,rmse_sea_add,rmse_Add_sea_Quad,rmse_multi_sea,rmse_multi_add_sea))
View(tablermse)
colnames(tablermse)<-c("model","RMSE")
View(tablermse)
