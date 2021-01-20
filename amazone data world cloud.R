library(tm)
library('NLP')
library(slam)
library(topicmodels)
library(textclean)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)

myt <- readLines("C:/Users/Smeeta/Downloads/vjamazon")

corpus <-  removePunctuation(replace_curly_quote(myt))
corpus <- removeWords(corpus, stopwords(kind = 'en'))
corpus<- removeNumbers(corpus)

writeLines(corpus)

s_v <- get_sentences(corpus)
class(s_v)
str(s_v)
head(s_v)

sentiment_vector <- get_sentiment(s_v, method = "bing")
head(sentiment_vector)

sum(sentiment_vector)
mean(sentiment_vector)
summary(sentiment_vector)

# To extract the sentence with the most negative emotional valence
negative <- s_v[which.min(sentiment_vector)]
negative

# and to extract the most positive sentence
positive <- s_v[which.max(sentiment_vector)]
positive


# in depth
poa_v <- corpus
poa_sent <- get_sentiment(poa_v, method="bing")

plot( poa_sent, type="h", main="Example Plot Trajectory", xlab = "Narrative Time", 
      ylab= "Emotional Valence")


# percentage based figures
percent_vals <- get_percentage_values(poa_sent)

plot(  percent_vals, type="l", main="Throw the ring in the volcano Using Percentage-Based Means", 
       xlab = "Narrative Time", ylab= "Emotional Valence", col="red" )


ft_values <- get_transformed_values(poa_sent, low_pass_size = 3, x_reverse_len = 100, scale_vals = TRUE,
                                    scale_range = FALSE)

plot(ft_values, type ="h",   main ="LOTR using Transformed Values", 
     xlab = "Narrative Time", ylab = "Emotional Valence", col = "red")

# categorize each sentence by eight emotions

nrc_data <- get_nrc_sentiment(s_v)
nrc_score_sent <- get_nrc_sentiment(negative)
nrc_score_word <- get_nrc_sentiment('grim')

#### generate negative  wordcloud 
set.seed(1234)
wordcloud(words = negative, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

####generate positive wordcloud
set.seed(1234)
wordcloud(words = positive, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
