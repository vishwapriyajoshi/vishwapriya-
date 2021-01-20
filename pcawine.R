wine <- read.csv("C:/Users/user/Downloads/wine.csv")
View(wine)

pcaObj<-princomp(wine, cor = TRUE, scores = TRUE, covmat = NULL)
str(pcaObj)
summary(pcaObj)

loadings(pcaObj)
plot(pcaObj)
biplot(pcaObj)
  
plot(cumsum(pcaObj$sdev*pcaObj$sdev)*100/(sum(pcaObj$sdev*pcaObj$sdev)),type="b")
pcaObj$scores[,1:4] 

wine<-cbind(wine,pcaObj$scores[,1:4])
View(wine)

wineclus<-wine[,15:18]

winecluss<-scale(wineclus) # Scale function is used to normalize data
dist1<-dist(winecluss,method = "euclidean") # method for finding the distance
# here I am considering Euclidean distance
fit1<-hclust(dist1,method="complete")
plot(fit1) # Displaying Dendrogram
groups<-cutree(fit1,3) # Cutting the dendrogram for 5 clusters
membership_1<-as.matrix(groups) # cluster numbering 
View(membership_1)
final1<-cbind(membership_1,wine) # binding column wise with orginal data
View(final1)
View(aggregate(final1,by=list(membership_1),FUN=mean))
