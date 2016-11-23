
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

library(jpeg)
library(tesseract)
library(wordcloud)
library(tm)
library(RColorBrewer)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("OCR an image with the tesseract package"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
      
      fileInput('file1', 'Choose an image (max 5MB)'),
      tags$hr(),
      numericInput("maxwords", "Max number words in cloud",value=100),
      numericInput("minfreq", "Minimum word frequency in cloud", value=2),
      checkboxInput("stopwords", "Remove (English) stopwords", value = FALSE)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Introduction",
          htmlOutput("intro")
        ),
        tabPanel(
          "Image to OCR",
          imageOutput("plaatje")
        ),
        tabPanel(
          "Extracted text",
          verbatimTextOutput("OCRtext")
        ),
        tabPanel(
          "Wordcloud",
          plotOutput("cloud", height = "800px")
        )
      )
    )
  )
))
