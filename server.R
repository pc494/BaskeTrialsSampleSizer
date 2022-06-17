function(input, output, session){
  ### Sigma list ####
  output$variance <- renderUI({
    tags <- tagList()
    for (i in seq_len(input$K)) {
      tags[[i]] <- numericInput(paste0('K', i),
                                HTML(paste0('\u03C3_{',i,'}')),
                                value=0)
    }
    tags
  })
  ### R list ###
  reactive_use_equal_alloc_ratio<-reactive({input$use_equal_alloc_ratio_bool})
  output$allocratio <- renderUI(
    if (reactive_use_equal_alloc_ratio()){
      # This means we do not render an R column
    }
    else
    {
    tags <- tagList()
    for (i in seq_len(input$K)) {
      tags[[i]] <- numericInput(paste0('K', i),
                                paste0('R_{', i,'}'),
                                value=0.5)
    }
    tags
  })

  ### Button to display inputs ####
  output$value <- renderText({
    input$update
    isolate(paste0("K = ",input$K,", the value of eta is: ", input$eta, " and " , input$use_equal_alloc_ratio_bool))
  })
}
