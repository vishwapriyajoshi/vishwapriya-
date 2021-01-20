library(recommenderlab)
library(caTools)
library(readr)
books <- read_csv("C:/Users/user/Downloads/book.csv")
View(books)
colnames(books)[6]<- "Rating"
colnames(books)[2]<- "users"


vj<-books[,c(4,5,6)]
View(vj)

str(vj)
head(vj)
summary(vj)
head(Rating)
library(Matrix)
library(recommenderlab)
library(recosystem)

vjmr<- as(vj,"realRatingMatrix")



