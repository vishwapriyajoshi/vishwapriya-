movies <- read.csv("C:/Users/Admin/Downloads/my_movies.csv")
View(movies)
movies<- movies[6:15]

# count of each item from all the transactions 
barplot(sapply(movies,sum),col=1:10)

# Applying apriori algorithm to get relevant rules
library(arules)
library(arulesViz)
moviesrules <- apriori(as.matrix(movies),parameter = list(support=0.002,confidence=0.5,minlen=2))
inspect(moviesrules)
plot(moviesrules)

# Sorting rules by confidence 
mocrules <- sort(moviesrules,by="confidence")
inspect(mocrules)

# Sorint rules by lift ratio
mruleslift <- sort(mocrules,by="lift")
inspect(mruleslift)

# Visualizing rules in scatter plot
plot(mocrules,method = "graph")


## Two-key plot is a scatterplot with shading = "order"
plot(moviesrules, shading="order", control=list(main = "Two-key plot", 
                                                col=rainbow(5)))

###usig matrix plot with movies rules 
plot(moviesrules, method="matrix", measure=c("lift", "confidence"))


