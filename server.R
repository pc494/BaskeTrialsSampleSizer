function(input, output, session){
  output$variance <- renderUI({
    tags <- tagList()
    for (i in seq_len(input$K)) {
      tags[[i]] <- numericInput(paste0('K', i), 
                                HTML(paste0('\u03C3_{',i,'}')),
                                value=0)
    }
    tags
  })
  output$allocratio <- renderUI({
    tags <- tagList()
    for (i in seq_len(input$K)) {
      tags[[i]] <- numericInput(paste0('K', i), 
                                paste0('R_{', i,'}'),
                                value=0)
    }
    tags
  })
  
}
#tags$sub(i))