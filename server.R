function(input, output, session){
  output$var <- renderUI({
    tags <- tagList()
    for (i in seq_len(input$K)) {
      tags[[i]] <- numericInput(paste0('K', i), 
                                paste0('Sigma Value ', i),
                                0)
    }
    tags
  })
}

#observeEvent(input$min, {
#  updateSliderInput(inputId = "n", min = input$min)
#})  