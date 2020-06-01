
options(shiny.maxRequestSize = 200*1024^2)

shinyServer(function(input, output, session){
#wordcloud
  observe({
    if(input$submit1 > 0){
      isolate({
        datatype <<- input$datatype
        uploadata <<- input$uploadata
        language <<- input$language
        colortext <<- input$colortype 
        if(colortext == 1){
          color <<- input$randomcolor
        } else{
          color <<- input$customcolor
        }
        
        if(datatype == 1){
          data1 <- read.table(input$file$datapath, as.is=T, head=F)
          colnames(data1) = c("Word","freq")
          result = data1[data1$freq>=input$freq,]
          
        } else {
          if(uploadata == 1){
            text = readLines(input$file$datapath, encoding="UTF-8")
          } else{
            text = input$pastetext
          }
          if(language == 1){
            text = text[text!=""]
            textl = lapply(text, strsplit," ")
            textu = unlist(textl)
            textg = gsub("\\.|,|\\!|:|;|\\?|\\d","",textu)
            textg = textg[textg!=""]
            data2 = as.data.frame(table(textg))
            colnames(data2) = c("Word","freq")
            data2 = data2[data2$freq>=input$freq,]
            words <- as.data.frame(readLines("ci.txt"))
            colnames(words) = "Word"
            result = anti_join(data2,words,by="Word")
          } else {
            text = text[text!=""]
            textg <- gsub("[a-zA-Z0-9 1 2 3 4 5 6 7 8 9 0]","",text)
            textu = unlist(lapply(X = textg,FUN = segmentCN))
            textl = lapply(X = textu,FUN = strsplit," ")
            data2 = as.data.frame(table(unlist(textl)))
            colnames(data2) = c("Word","freq")
            data2 = data2[data2$V1>=input$freq,]
            words <- as.data.frame(readLines("ci.txt", encoding="UTF-8"))
            colnames(words) = "Word"
            result = anti_join(data2,words,by="Word")
          }
        }
        
        output$wordcloud2 <- renderWordcloud2({
          wordcloud2(result,
                     size = input$size,
                     shape = input$shape,
                     color = color,
                     backgroundColor = input$backgroundColor)
        })
      })
    } else{
      NULL
    }
  })
 
  #  Download example data (processed data)
  output$processed_data.txt <- downloadHandler(
    filename <- function() {
      paste('processed_data.txt')
    },
    content <- function(file) {
      input_file <- "www/data/download_example_data/processed_data.txt"
      example_dat <- read.table(input_file, head = T, as.is = T, sep = "\t", quote = "")
      write.table(example_dat, file = file, row.names = F,col.names = F, quote = F, sep = "\t")
    }, contentType = 'text/csv')
  #  Download example data (processed data)
  output$raw_data.txt <- downloadHandler(
    filename <- function() {
      paste('raw_data.txt')
    },
    content <- function(file) {
      input_file <- "www/data/download_example_data/raw_data.txt"
      example_dat <- read.table(input_file, head = T, as.is = T, sep = "\t", quote = "")
      write.table(example_dat, file = file, row.names = F,col.names = F, quote = F, sep = "\t")
    }, contentType = 'text/csv')
})   
