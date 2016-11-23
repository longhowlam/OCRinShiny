
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {
  
  extractedText <- reactive({
    
    progress <- Progress$new(session, min=1, max=15)
    on.exit(progress$close())
    
    progress$set(
      message = 'OCR in progress', 
      detail = 'This may take 5-10 sec...'
    )
    
    inFile = input$file1
    
    if (!is.null(inFile))
    {
      Extext <- ocr(inFile$datapath)
    }
    else
    {
      Extext <- ocr("www/ocr-test.jpg")
    }
    Extext
  })
  
  output$intro <- renderUI({
    list(
      img(SRC="ocrplaatje.jpg"),
      h4("This shiny app uses the tesseract R package to perform OCR on an uploaded image."), 
      h4("The extracted text is then used to form a wordcloud image, (English) stopwords can be removed"),
      h4("If no image is selected a default ocr test image is used. The R source can be found on my ", a("github", href="https://github.com/longhowlam/OCRinShiny")),
      h4("Cheers, Longhow")
    )
    
  })
  
  output$plaatje <- renderImage({
    
    inFile = input$file1
    print(inFile)
    if (!is.null(inFile))
    {
      
      width  <- session$clientData$output_plaatje_width
      height <- session$clientData$output_plaatje_height
      list(
        src = inFile$datapath,
        width=width,
        height=height
      )
    }
    else
    {
      list(src="www/ocr-test.jpg")
    }
  },
  deleteFile = FALSE
  )
  
  
  output$OCRtext = renderPrint({
    
      
    cat(extractedText())
  })
  
  output$sentences = renderDataTable({
    
    text = extractedText()
    tmp = tokenize(text, what = "sentence")
    DT::datatable(  
      data.frame(
        sentence = 1:length(tmp[[1]]),
        text = tmp[[1]]
      ),
      rownames = FALSE
      
    )
    
  })
  
  
  output$cloud = renderPlot({
    
    text = extractedText()
    cp = Corpus(VectorSource(text))
    cp = tm_map(cp, content_transformer(tolower))
    cp = tm_map(cp, removePunctuation)
    if(input$stopwords){
      cp = tm_map(cp, removeWords, stopwords('english'))
    }
    
    pal <- brewer.pal(9,"BuGn")
    pal <- pal[-(1:4)]
    wordcloud(
      cp, 
      max.words = input$maxwords,
      min.freq = input$minfreq,
      random.order = FALSE,
      colors = pal
    )
    
  })
  
  
  
})
