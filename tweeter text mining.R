

devtools::install_github("jrowen/twitteR", ref = "oauth_httr_1_0")
library("twitteR")
install.packages("ROAuth")
library("ROAuth")


cred <- OAuthFactory$new(consumerKey='BagGgBbanzbdpPNNp8Uy6TQBP', # Consumer Key (API Key)
                         consumerSecret='pFxap1Jzc1fClDQ9psLNU3RKSQ5FvS2PhJz8E2R7ix0cawPKfa', #Consumer Secret (API Secret)
                         requestURL='https://api.twitter.com/oauth/request_token',                accessURL='https://api.twitter.com/oauth/access_token',                 authURL='https://api.twitter.com/oauth/authorize')

save(cred, file="twitter authentication.Rdata")
load("twitter authentication.Rdata")

setup_twitter_oauth("BagGgBbanzbdpPNNp8Uy6TQBP", # Consumer Key (API Key)
                    "pFxap1Jzc1fClDQ9psLNU3RKSQ5FvS2PhJz8E2R7ix0cawPKfa", #Consumer Secret (API Secret)
                    "1076425245521731584-Ev31ZLB7Cf0idVMqDI8BxiVG2SgRnu",  # Access Token
                    "ZVUw0Z0mFrX7d6sjQxuB08l48JHhmnjmlAm86G2OPG7BS")

Tweets <- userTimeline('facebook', n = 1000,includeRts = T)
TweetsDF <- twListToDF(Tweets)
dim(TweetsDF)

View(TweetsDF)
setwd("C:/ccc/cccc")

write.csv(TweetsDF, "Tweets.csv",row.names = F)
