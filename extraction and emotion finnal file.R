######## before run the code pakage should be install and run the code#####
library(tm)
library('NLP')
library("syuzhet")
library(slam)
library(topicmodels)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(SnowballC)
library(rvest)

## Using While loop to get all reviews without using page number yu tv ############## 
#### extraction amazon Yu tv data ##################################################
samp_url <- "https://www.amazon.in/inches-Ready-UltraAndroid-32GA-Black/product-reviews/B07XMD275Q/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews"
i=1
p=1
predator <- NULL
while(p>0){
  t_url <- read_html(as.character(paste(samp_url,i,sep="=")))
  rev <- t_url %>%
    html_nodes(".review-text") %>%
    html_text()
  predator <- c(predator,rev)
  i <- i+1
  p=length(rev)
}
length(predator)

write.table(predator,"prj.txt",row.names = FALSE)

############## readlines the extracting data##########
myt  <- readLines("C:/Users/smeeta/Downloads/prj.txt")
docs<- Corpus(VectorSource(myt))
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
tb <- as.data.frame.matrix(dtm.new)
dim(tb)

##### selected colums and rows make data sets
ab<- tb[1:10]
############# build the svm model################ 
bc<- data.frame(lapply(ab, factor))
View(bc)
write.csv(bc,"prjs.csv", row.names = TRUE) 


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
     
####generate all words. wordcloud
set.seed(1234)
wordcloud(words = poa_v, min.freq = 1,
               max.words=200, random.order=FALSE, rot.per=0.35, 
               colors=brewer.pal(8, "Dark2"))
     
     
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
     