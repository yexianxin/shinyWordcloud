library(shiny)
library(shinyBS)

shinyUI(
  navbarPage(
    title = "shinyWordcloud",
    windowTitle = "make wordcloud in R with shiny",
    theme = shinytheme("flatly"),
    tabPanel(
      "wordcloud",
      sidebarPanel(
        radioButtons("datatype", h4("Upload data type",
                                    bsButton("bs1", label="", icon=icon("question"), style="info", size="small")
        ), c("processed data" = "1", "raw data" = "2"), "1"),
        bsPopover("bs1", 'Select upload data type, "processed data" requires two columns in the data set, the first column is word,  the second column is word frequency, and "raw data" is unprocessed data.',
                  trigger = "focus"),
        conditionalPanel(condition = "input.datatype == '1'",
                         downloadButton("processed_data.txt", "Example data")
                         
        ),
        conditionalPanel(condition = "input.datatype == '2'",
                         downloadButton("raw_data.txt", "Example data")
                         
        ),
        
        conditionalPanel(condition = "input.datatype == '2'",
                         radioButtons("uploadata", h5("Upload data",
                                                      bsButton("bs2", label="", icon=icon("question"), style="info", size="small")
                         ), c("upload file" = "1", "paste text" = "2"),"1")),
        bsPopover("bs2", "Choose how to upload data",
                  trigger = "focus"),
        
        conditionalPanel(condition = "input.uploadata == '1'|input.datatype == '1'",	
                         fileInput("file", h5("Upload file",
                                              bsButton("bs3", label="", icon=icon("question"), style="info", size="small")
                         ), multiple = FALSE)),
        bsPopover("bs3", 'Click "Browse" to upload the file and upload the corresponding data set according to the "datatype" option.',
                  trigger = "focus"),
        
        conditionalPanel(condition="input.uploadata == '2'",	
                         textAreaInput("pastetext", h5("The area of pasting texts",
                                                       bsButton("bs4", label="", icon=icon("question"), style="info", size="small")
                         ),"Paste text to upload data", height = "400px")),
        bsPopover("bs4", 'Paste the text to upload the data and upload the appropriate data set based on the "datatype" option.',
                  trigger = "focus"),
        
        conditionalPanel(condition = "input.datatype == '2'",
                         radioButtons("language", h4("Language type",
                                                     bsButton("bs5", label="", icon=icon("question"), style="info", size="small")
                         ), c("English" = "1","Chinese" = "2"),"1")),
        bsPopover("bs5","Select the language type of the text you upload.",
                  trigger = "focus"),
        
        sliderInput("freq", h4("Minimum frequency of words",
                               bsButton("bs6", label="", icon=icon("question"), style="info", size="small")
        ), min = 1, max = 20, value = 2),
        bsPopover("bs6", "An integer in [1,20] that sets the minimum value of word frequency.",
                  trigger = "focus"),
        sliderInput("size", h4("Size of words",
                               bsButton("bs10", label="", icon=icon("question"), style="info", size="small")
        ), min = 0.05, max = 5, value = 1),
        radioButtons("colortype", h4("the color of text",
                                     bsButton("bs7", label="", icon=icon("question"), style="info", size="small")
        ), c("Random" = "1", "Custom" = "2"),"1"),
        bsPopover("bs7", "Select the color of the text.",
                  trigger = "focus"),
        
        conditionalPanel(condition = "input.colortype == '1'",
                         radioButtons("randomcolor", "Random color",
                                      c("random-dark" = "random-dark",
                                        "random-light" = "random-light"))
        ),
        conditionalPanel(condition = "input.colortype == '2'",
                         colourInput("customcolor", h5("Customize the text color", 
                                                     bsButton("bs8", label="", icon=icon("question"), style="info", size="small")
                         ),"skyblue", returnName = TRUE, allowTransparent = TRUE)
        ),
        bsPopover("bs8", 'choose the color of the text, you can click the form to choose color or entre the color of text, for example:"red" "blue" "black" ect.',
                  trigger = "focus"),
        
        colourInput("backgroundColor", h4("Set the background color",
                                        bsButton("bs9", label="", icon=icon("question"), style="info", size="small")
        ),"white", returnName = TRUE, allowTransparent = TRUE ),
        bsPopover("bs9", 'choose the color of background, you can choose color by clicking the form or enter the color ,for example: "white";"grey";"black", etc.',
                  trigger = "focus"), 
        radioButtons("shape", h5("Shape of wordcloud",
                                 bsButton("bs0", label="", icon=icon("question"), style="info", size="small")),
                     list("circle" = "circle",
                          "cardioid" = "cardioid",
                          "star" = "star",
                          "diamond" = "diomand",
                          "triangle" = "triangle",
                          "pentagon" = "pentagon")),
        bsPopover("bs0", "Set the pattern of words.",
                  trigger = "focus"),
        
                  actionButton("submit1", strong("Go!"))
      ),
      mainPanel(
        wordcloud2Output("wordcloud2", width = "100%", height = "600px")
      )
    ),
    
    tabPanel("Usage and installation", includeMarkdown("README.md")),
    navbarMenu("Help",
               tabPanel("User manaul", includeHTML("User_manual.html")),
               tabPanel("User manaul in Chinese", includeHTML("User_manual_in_Chinese.html"))
    ),
    tabPanel("About",includeMarkdown("About.md"))
  )
)
