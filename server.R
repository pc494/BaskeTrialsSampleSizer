source("subfun_and_simulators.R")

function(input, output, session)
{
  ### This first section deals with adaptive element of the UI that do not involve direct mathematical calculation
  
  # are we using borrowing?
  reactive_borrowing <- reactive({!input$borrowing}) #this not character keeps the switch going the right way
  
  # write out all the hyper-parameter selections
  output$desc <- renderText(paste0("Results calculated with \u03B4=",input$delta,", \u03B7=",input$eta,', \u03B6=',input$zeta))
  #output$desc <- renderText(str(r_vect()))
  
  # create the extra table information switch (if and only if we have borrowing turned on)
  
  output$extra_table_switch <- renderUI(
    if (reactive_borrowing()){
      materialSwitch(inputId = "debug", label = "Extra Table Detail? (True/False)", value=TRUE ,status = "default")})
  
  # create the borrowing slider (if and only if we have borrowing turned on)
  output$borrowing_slider <- renderUI(
    if (reactive_borrowing()){
    sliderTextInput(
    inputId = "LoB",
    label = "Level of Borrowing",
    grid = FALSE,
    force_edges = TRUE,
    choices = c("Moderate", "Strong")
  )})
  
  # create a sigma list that varies length with the value of k #
  output$variance <- renderUI({
    num <- as.integer(input$K)
    
    lapply(1:num, function(i) {
      numericInput(paste0("var_", i), label = HTML(paste0('\u03C3<sub>',i,'</sub>')), value = 10)
    })
  })
  
  ### create an R list that is off, unless turned on, and then varies with the value of k ###
  epsilon <- 0.05 # so that R can be close to, but not equal to, 1.
  reactive_use_equal_alloc_ratio<-reactive({input$use_equal_alloc_ratio_bool})
  output$allocratio <- renderUI(
    if (!reactive_use_equal_alloc_ratio()){
      # This means we do not render an R column
    }
    else
    {
      num <- as.integer(input$K)
      
      lapply(1:num, function(i) {
        numericInput(paste0("R_", i), label = HTML(paste0('R<sub>',i,'</sub>')), value = 0.5, min = epsilon, max = 1-epsilon, step = 0.05)
      
      })
  })
  
  ### Start the calculation phase
  
  # Get character vectors for R and sigma 
  reactive_K <- reactive({input$K})
  sigma_vect <- reactive({sapply(1:reactive_K(), function(i) {input[[paste0("var_", i)]]})})
  
  r_vect <- reactive({
                    if (!reactive_use_equal_alloc_ratio()){
                      #full vector of 50% allocations
                      replicate(input$K,0.5)
                      } 
                    else {
                      # This throws an edge case (harmless error) because the UI 'reacts slower' than the sapply function.
                      sapply(1:reactive_K(), function(i) {input[[paste0("R_", i)]]})
                      }
                    })

  ### Now need to calculate results and draw the table. (in development)
  
  reactive_n <- reactive({
    if(!reactive_borrowing()) {
      NoBrwNi(sigma_vect(),r_vect(),input$eta,input$zeta,input$delta,input$ssq)
      }
    })
  
  output$table <- renderUI(
    if (!reactive_borrowing()){ 
                          renderTable(data.frame('k'=1:reactive_K(),
                         '\u03C3<sub>k</sub>'=sigma_vect(),
                         'n<sub>R</sub>' = as.integer(ceiling(reactive_n())),
                         'n<sub>T</sub>'=as.integer(reactive_n()*r_vect()+0.5),
                         'n<sub>C</sub>'=as.integer(reactive_n()*(1-r_vect())+0.5),
                         check.names=FALSE),
              sanitize.colnames.function = function(x) x)}
    )
  
}
