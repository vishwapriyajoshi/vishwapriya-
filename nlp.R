
######## extracting data amazon redmi k20 data  #######

aurl <- "https://www.amazon.in/Redmi-K20-Pro-Flame-Storage/product-reviews/B082FN5WR4/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews"
amazon_reviews <- NULL
for (i in 1:10){
  murl <- read_html(as.character(paste(aurl,i, sep="=")))
  gtrev <- murl %>%
    html_nodes(".review-text") %>%
    html_text()
  amazon_reviews <- c(amazon_reviews,gtrev)
}
write.table(amazon_reviews,"vjamazon",row.names = FALSE)



# ############# IMDB reviews Extraction ################
a<-10
wonder_woman<-NULL
url1<-"https://www.imdb.com/title/tt1477834/reviews?ref_=tt_ov_rt"
for(i in 0:22){
  url<-read_html(as.character(paste(url1,i*a,sep="")))
  wonder<-url %>%
    html_nodes(".show-more__control") %>%
    html_text() 
  wonder_woman<-c(wonder_woman,wonder) }
write.table(wonder_woman,"wonder_womans",row.names = FALSE)

