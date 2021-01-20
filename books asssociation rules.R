book <- read.csv("C:/Users/Admin/Downloads/book.csv")
View(book)
str(book)

# Association Rules 

library(arules)
library(arulesViz)

# Item Frequecy plot
windows()

# count of each item from all the transactions 
barplot(sapply(book,sum),col=1:11)

# Applying apriori algorithm to get relevant rules

rules <- apriori(as.matrix(book),parameter = list(support=0.002,confidence=0.5,minlen=2))
inspect(rules)
plot(rules)

# Sorting rules by confidence 
rulesconf <- sort(rules,by="confidence")
inspect(rulesconf)

# Sorint rules by lift ratio
ruleslift <- sort(rules,by="lift")
inspect(ruleslift)

# Visualizing rules in scatter plot
plot(rules,method = "graph")

## Two-key plot is a scatterplot with shading = "order"
plot(rules, shading="order", control=list(main = "Two-key plot", 
                                          col=rainbow(5)))

###usig matrix plot with  rules 
plot(rules, method="matrix", measure=c("lift", "confidence"))

