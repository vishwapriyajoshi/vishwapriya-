library(tm)
library(caret)
library(e1071)
library(gmodels)



myts  <- read.csv("C:/Users/user/Downloads/emails.csv")
myt <- myts[1:4000,4:5]
View(myt)
myt$Class <- factor(myt$Class)
str(myt$Class)
table(myt$Class)

docss<- Corpus(VectorSource(myt$content))
docss <- tm_map(docss,function(x) iconv(enc2utf8(x),sub = 'byte'))
########## clenening the text data 
toSpace <- function (x , pattern ) gsub(pattern, " ", x)
docs <- tm_map(docss, toSpace, "/")                         
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, stemDocument)

mydata.dtm3 <- TermDocumentMatrix(docs)
View(mydata.dtm3)

rawtrain <- myt[1:3000,]
rawtest <- myt[3001:4000,]

dtmtrain <-mydata.dtm3[1:3000,]
dtmtest <- mydata.dtm3[3001:4000,]


docstrain <- docs[1:3000]
docstest  <- docs[3001:4000]

prop.table(table(rawtrain$Class))
prop.table(table(rawtrain$Class))


dtmdict <- findFreqTerms(dtmtrain,5)

train <- DocumentTermMatrix(docstrain,list(dictonary = dtmdict))
test <- DocumentTermMatrix(docstest,list(dictonary = dtmdict))

##########converts to count factor()
##########custom function : if a word is used more than 0 times then mention 1else mention as factor
convert_counts <- function(x) {
  x<- ifelse(x >0,1,0)
  x <- factor(x, level = c(0,1),labels = c('NO','Yes'))
  }


########## apply() covert() to columns of train /test data 
########## margin = 2 is for columns
########## margin = 2 is for rows
emailtrain <- apply(train,MARGIN = 2,convert_counts)
emailtest <- apply(test,MARGIN = 2,convert_counts)


########## model build
model<-naiveBayes(emailtrain,rawtrain$Class)
model


pred <- predict(model,emailtest)
table(pred)
prop.table(table(pred))

Crosstable(pred,rawtest$Class,
           prop.chisq = FALSE,prop.t = FALSE,prop.r = FALSE,
           dnn = c('predicted','actual'))





