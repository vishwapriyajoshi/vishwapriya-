library(shiny)
library(tm)
library(wordcloud)
library(shiny)
library("syuzhet")
library(kernlab)

### delete x colum in csv file after run the code

##################### svm model prediction rshyni #####################

ui <- fluidPage(
  titlePanel("prediction"),
  sidebarLayout(
    sidebarPanel(
      numericInput("num","amazon",1),
      numericInput("num1","also",1),
      numericInput("num2","android",1),
      numericInput("num3","app",1),
      numericInput("num4","around",1),
      numericInput("num5","buy",1),
      numericInput("num6","come",1),
      numericInput("num7","complaint",1),
      numericInput("num8","contact",1),
      numericInput("num9","custom",1)
    ),
    mainPanel(
      tableOutput("distplot")
    )  )
)



server <- function(input, output) {
  output$distplot <- renderTable({
    as <- read.csv("C:/Users/smeeta/Downloads/prjs.csv")
    
    asmodel1<-ksvm(amazon ~.,data = as,kernel = "vanilladot")
    nw=data.frame(amazon=input$num,   also=input$num1,
                  android=input$num2, app=input$num3,
                  around=input$num4,  buy=input$num5,
                  come=input$num6,    complaint=input$num7,
                  contact=input$num8, custom=input$num9)
    
    nw
    w= predict(asmodel1,nw)
    w
  })
  
}
shinyApp(ui=ui, server=server)




#####################emotion mining########################

ui <- fluidPage(
  titlePanel("Emotions"),
  sidebarLayout(
    sidebarPanel(
      fileInput("wc","TEXT FILE", multiple = F, accept = "text/plain")
    ),
    mainPanel(
      plotOutput("wcplot")
    )
  )
)

server <- function(input, output, session) {
  wc_data <- reactive({
    
    input$update
    
    isolate({
      
      withProgress({
        setProgress(message = "processing corpus...")
        wc_file<- input$wc
        wc_text<- readLines("C:/Users/smeeta/Downloads/prj.txt")
        
        wc_corpus<- Corpus(VectorSource(wc_text))
        toSpace <- function (x , pattern ) gsub(pattern, " ", x)
        wc_corpus_clean <- tm_map(wc_corpus, toSpace, "/")                         
        wc_corpus_clean <- tm_map(wc_corpus_clean, toSpace, "@")
        wc_corpus_clean <- tm_map(wc_corpus_clean, toSpace, "\\|")
        wc_corpus_clean <- tm_map(wc_corpus_clean, tolower)
        wc_corpus_clean <- tm_map(wc_corpus_clean, removeNumbers)
        wc_corpus_clean <- tm_map(wc_corpus_clean, removeWords, stopwords("english"))
        wc_corpus_clean <- tm_map(wc_corpus_clean, removeWords, c("blabla1", "blabla2")) 
        wc_corpus_clean <- tm_map(wc_corpus_clean, removePunctuation)
        wc_corpus_clean <- tm_map(wc_corpus_clean, stripWhitespace)
        wc_corpus_clean <- tm_map(wc_corpus_clean, stemDocument)
        wc_corpus_clean<- as.character(wc_corpus_clean)
        wc_corpus_clean<- get_nrc_sentiment(wc_corpus_clean)
        
        
      })
    })
  }) 
  
  
  wordcloud_rep<- repeatable(wordcloud)
  
  output$wcplot <- renderPlot({
    
    withProgress({
      setProgress(message = "processing corpus...")
      wc_corpus<- wc_data()
      colu<- rainbow(20)
      barplot(sort(colSums(prop.table(wc_corpus[, 1:10]))), horiz = T, cex.names = 0.7,
              las = 1, main = "Emotions", xlab = "Percentage",
              col = 1:8)
    })
  })
  
}

shinyApp(ui=ui,server=server)

############################# wordcloud genrating################


ui <- fluidPage(
  titlePanel("word cloud"),
  sidebarLayout(
    sidebarPanel(
      fileInput("wc","upload a text file for wordcloud", multiple = F, accept = "text/plain"),
      sliderInput("wordfreq","select the min frequency of word",1,10,1),
      sliderInput("maxword","select the max number of words",1,500,100),
      checkboxInput("random","Random order?"),
      radioButtons("color","select the wordcloud color theme",c("Accent","dark"),selected = "Accent"),
      actionButton("update","create word cloud")
    ),
    mainPanel(
      plotOutput("wcplot")
    )
  )
)

server <- function(input, output, session) {
  wc_data <- reactive({
    
    input$update
    
    isolate({
      
      withProgress({
        setProgress(message = "processing corpus...")
        wc_file<- input$wc
        wc_text<- readLines("C:/Users/smeeta/Downloads/prj.txt")
        
        wc_corpus<- Corpus(VectorSource(wc_text))
        toSpace <- function (x , pattern ) gsub(pattern, " ", x)
        wc_corpus_clean <- tm_map(wc_corpus, toSpace, "/")                         
        wc_corpus_clean <- tm_map(wc_corpus_clean, toSpace, "@")
        wc_corpus_clean <- tm_map(wc_corpus_clean, toSpace, "\\|")
        wc_corpus_clean <- tm_map(wc_corpus_clean, tolower)
        wc_corpus_clean <- tm_map(wc_corpus_clean, removeNumbers)
        wc_corpus_clean <- tm_map(wc_corpus_clean, removeWords, stopwords("english"))
        wc_corpus_clean <- tm_map(wc_corpus_clean, removeWords, c("blabla1", "blabla2")) 
        wc_corpus_clean <- tm_map(wc_corpus_clean, removePunctuation)
        wc_corpus_clean <- tm_map(wc_corpus_clean, stripWhitespace)
        wc_corpus_clean <- tm_map(wc_corpus_clean, stemDocument)
        
        
      })
    })
  })
  
  wordcloud_rep<- repeatable(wordcloud)
  
  output$wcplot <- renderPlot({
    
    withProgress({
      setProgress(message = "processing corpus...")
      wc_corpus<- wc_data()
      
      wc_color= brewer.pal(8,"Dark2")
      
      if(input$color=="Accent"){
        wc_color = brewer.pal(8,"Accent")
      }
      else(
        wc_color=brewer.pal(8,"set2")
      )
      wordcloud(wc_corpus,min.freq = input$wordfreq,max.words= input$maxword,colors = wc_color,random.order = input$random,rot.per = .30)
    })
  })
  
}

shinyApp(ui=ui,server=server)






