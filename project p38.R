library(tm)
library('NLP')
library("syuzhet")
library(slam)
library(topicmodels)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(SnowballC)

########## read csv ##########
myts  <- read.csv("C:/Users/user/Downloads/emails.csv")
myt <- myt[1:15000,4:5]
myt$Class <- ifelse(myt$Class=='Abusive',1,0)
str(myt)
table(myt$Class)

########## create in corpus each setence in one line ##########
docs<- Corpus(VectorSource(myt$content))
########## clenening the text data 
toSpace <- function (x , pattern ) gsub(pattern, " ", x)
docs <- tm_map(docs, toSpace, "/")                         
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, stemDocument)

##### build the term document matrix###########
# dtm <- as.DocumentTermMatrix(mydata.dtm3)
mydata.dtm3 <- TermDocumentMatrix(docs)
mydata.dtm3
dim(mydata.dtm3)

###### removing spares################# 
sf<- removeSparseTerms(mydata.dtm3,0.99)
dtm <- t(sf)
rowTotals <- apply(dtm, 1, sum)
dtm.new   <- dtm[rowTotals > 0, ]
dim(dtm.new)
View(dtm.new)
tb <- as.data.frame.matrix(dtm.new)
dim(tb)
View(tb)
colnames(tb) = make.names(colnames(tb))


##### selected colums and rows make data sets
ab<- tb[1:15]
############# build the svm model################ 
bc<- data.frame(lapply(ab, factor))
View(bc)
write.csv(bc,"p38prj.csv", row.names = TRUE) 

##### emotinal mining#########
dd<- as.character(docs)##### docs convert as.character
######## get sentiment analysis 
s_v <- get_sentences(myt)
class(s_v)
str(s_v)
head(s_v)
############### being sentimenatal analysis ##############
sentiment_vector <- get_sentiment(s_v, method = "bing")
head(sentiment_vector)
sum(sentiment_vector)
mean(sentiment_vector)
summary(sentiment_vector)
#########affin sentimental analysis############
afinn_s_v <- get_sentiment(s_v, method = "afinn")
head(afinn_s_v)
############# nrc sentimental analysis########### 
nrc_vector <- get_sentiment(s_v, method="nrc")
head(nrc_vector)
# plot#
plot(sentiment_vector, type = "l", main = "Plot Trajectory",
     xlab = "Narrative Time", ylab = "Emotional Valence")
abline(h = 0, col = "red")

# To extract the sentence with the most negative emotional valence#######
negative <- s_v[which.min(sentiment_vector)]
negative

####generate negative wordcloud#########
library(wordcloud)
set.seed(1234)
wordcloud(words = negative, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.30, 
          colors=brewer.pal(8, "Dark2"))

# and to extract the most positive sentence####
positive <- s_v[which.max(sentiment_vector)]
positive

####generate positive wordcloud########
set.seed(1234)
wordc<-wordcloud(words = positive, min.freq = 1,
                 max.words=200, random.order=FALSE, rot.per=0.45, 
                 colors=brewer.pal(8, "Dark2"))

############ nrc sentimental analysis##########
mj<- get_nrc_sentiment(dd)
head(mj)
##barplot
barplot(colSums(mj),
        las=2, 
        col = rainbow(10),
        ylab = 'Count',
        main = 'sentiment scores for tv')



############### bar plot##############
tm0<- as.matrix(sf)
tm0[1:10,1:20]
w<- rowSums(tm0)
w<- subset(w,w>=20)
barplot(w,
        las =2,
        col = rainbow(25))

### wordcloud
w<-sort(rowSums(tm0),decreasing = T)
set.seed(123)
wordcloud(words = names(w),
          freq = w,
          max.words = 200,
          random.order = F,
          min.freq = 5,
          colors = brewer.pal(8,'Dark2'),
          scale = c(5,0.3),
          rot.per = 0.7)

###### wordcloud2#####################
library(wordcloud2)
m<- data.frame(names(w),w)
colnames(m)<- c('word','freq')
wordcloud2(m,
           size = 0.5,
           shape = 'star',
           rotateRatio = 0.7,
           minSize = 1)

############## finding the 10 topics in review data
library(topicmodels)
lda <- LDA(dtm.new, 10) # find 10 topics
lda
term <- terms(lda, 20) # first 20 terms of every topic
term
tops <- terms(lda)
vb <- table(names(tops), unlist(tops))
vb <- as.data.frame.matrix(tb)
cls <- hclust(dist(vb), method = 'ward.D2') #ward is absolute distance
par(family = "HiraKakuProN-W3")
plot(cls)

##########bigram ############################
library(RWeka)
library(tidytext)
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tdm.bigram = TermDocumentMatrix(docs,
                                control = list(tokenize = BigramTokenizer))
freq = sort(rowSums(as.matrix(tdm.bigram)),decreasing = TRUE)
freq.df = data.frame(word=names(freq), freq=freq)
head(freq.df, 20)
pal=brewer.pal(8,"Blues")
pal=pal[-(1:3)]


#Plot the wordcloud.
wordcloud(freq.df$word,freq.df$freq,max.words=100,random.order = F, colors=pal)
ggplot(head(freq.df,15), aes(reorder(word,freq), freq)) +
  geom_bar(stat = "identity") + coord_flip() +
  xlab("Bigrams") + ylab("Frequency") +
  ggtitle("Most frequent bigrams")


#########trigram ###########################
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
tdm.trigram = TermDocumentMatrix(docs,
                                 control = list(tokenize = TrigramTokenizer))
###Extract the frequency of each trigram and analyse the twenty most frequent ones.
freq = sort(rowSums(as.matrix(tdm.trigram)),decreasing = TRUE)
freq.df = data.frame(word=names(freq), freq=freq)
head(freq.df, 20)
wordcloud(freq.df$word,freq.df$freq,max.words=100,random.order = F, colors=pal)
ggplot(head(freq.df,15), aes(reorder(word,freq), freq)) +   
  geom_bar(stat="identity") + coord_flip() + 
  xlab("Trigrams") + ylab("Frequency") +
  ggtitle("Most frequent trigrams")


########## model building install package ##########
library(C50)
library(caret)
library(e1071)
library(kernlab)
library(e1071)
library(naivebayes)
library(ggplot2)
library(gmodels)


########## read csv file of converting dtm to csv file##########
as <- read.csv("C:/Users/user/Documents/p38prj.csv")
View(ms)
va<-data.frame(lapply(as,as.factor))
ms<- va[,2:10]

########## create data partition spliting the data train and test##########

sjsj<- createDataPartition(ms$ect,p=.75,list=F)
train<- ms[sjsj,]
test<- ms[-sjsj,]

####preparing the model svm with consider the train data  kernal is vanillodot###########
model1<-ksvm(ect ~.,data = train,kernel = "vanilladot")
model1
pred1 <-predict(model1,newdata=test)
svmaccuracy<-mean(pred1==test$ect)
pred1
####preparing the model svm rbfdot###########
model2<-ksvm(ect ~.,data = train, kernel = "rbfdot")
pred12<-predict(model2,newdata=test)
mean(pred12==test$ect) 
pred12
model2
####preparing the model svm polydot###########
model3<-ksvm(ect~.,data = train,kernel = "polydot")
pred13<-predict(model3,newdata=test)
mean(pred13==test$ect)
pred13
model3
####preparing the model svm besselodot###########
model4<-ksvm(train$android ~.,data = train,kernel = "besseldot")
pred14<-predict(model4,newdata=test)
mean(pred14==test$android) 
pred14
model4


##########navybase pakage e1071##########
model<-naiveBayes(ect~.,data=train)
pred<-predict(model,newdata = train)
navye1071accuracy<- mean(pred==train$ect)#train data accuracy=0.9
mean(pred==test$ect) # testdataAccuracy = 0.9 % 
# Confusion Matrix
confusionMatrix(train$ect, pred)
CrossTable(train$ect,pred)
ggplot(data = train ,aes(x = train$ect , y = train$around, fill = train$bet))+
  geom_boxplot()+
  ggtitle("BOXPLOT")

######### navybase model building pakage is naievybase###############
model <- naive_bayes(train$ect~.,data=train)
model
model_pred <- predict(model,test)
navybaseaccuracyorg<- mean(model_pred == test$ect)   #60%
#CONFUSIONMATRIX
confusionMatrix(test$ect, model_pred)


######## decision tree ##############
prc5.0_train <- C5.0(train[,-2],train$ect)
windows()
plot(prc5.0_train) # Tree graph
# Training accuracy
predtrain <- predict(prc5.0_train,train)
decisionaccuracy<- mean(train$ect==predtrain) # 0.9% Accuracy
confusionMatrix(predtrain,train$ect)##confusion matric for train data 
predc5.0_test <- predict(prc5.0_train,newdata=test) # predicting on test data
mean(predc5.0_test==test$ect) # 0.9 testaccuracy 
confusionMatrix(predc5.0_test,test$ect)
# Cross tables
CrossTable(test$ect,predc5.0_test)
################ all acccuracy data make data.frame easy to find out which is best ##########
accuracy <- data.frame(decisionaccuracy,navybaseaccuracyorg,navye1071accuracy,svmaccuracy)

