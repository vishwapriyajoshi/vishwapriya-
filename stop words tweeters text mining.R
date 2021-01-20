facebook <- read.csv(file.choose())
str(facebook)

library(tm)
corpus <- facebook$text
corpus <- Corpus(VectorSource(corpus))
inspect(corpus[1:5])


corpus <- tm_map(corpus, removePunctuation)

my_stopwords <- c(stopwords('english'))

corpus <- tm_map(corpus, removeWords, my_stopwords)

corpus <- tm_map(corpus, removeNumbers)

corpus <- tm_map(corpus, stripWhitespace)

## build a term-document matrix

mydata.dtm3 <- TermDocumentMatrix(corpus)
mydata.dtm3

dim(mydata.dtm3)

# dtm <- as.DocumentTermMatrix(mydata.dtm3)
# dtm <- DocumentTermMatrix(mydata.corpus)

dtm <- t(mydata.dtm3)
rowTotals <- apply(dtm, 1, sum)
?apply

dtm.new   <- dtm[rowTotals > 0, ]
dim(dtm.new)

lda <- LDA(dtm.new, 10) # find 10 topics
?LDA

term <- terms(lda, 20) # first 5 terms of every topic
term

tops <- terms(lda)
?terms
tb <- table(names(tops), unlist(tops))
tb <- as.data.frame.matrix(tb)
?unlist

cls <- hclust(dist(tb), method = 'ward.D2') #ward is absolute distance
?hclust
par(family = "HiraKakuProN-W3")
plot(cls)








