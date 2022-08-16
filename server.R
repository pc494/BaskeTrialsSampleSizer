source("subfun_and_simulators.R")

function(input, output, session)
{
  col_width <- 2 #value should be the same as in ui.R 
  
  ### This first section deals with adaptive element of the UI that do not involve direct mathematical calculation
  
  # are we using borrowing?
  reactive_borrowing <- reactive({!input$borrowing}) #this not character keeps the switch going the right way
  
  # write out all the hyper-parameter selections
  output$desc <- renderText(paste0("Results calculated with \u03B4=",input$delta,", \u03B7=",input$eta,', \u03B6=',input$zeta))
  #output$desc <- renderText(str(r_vect()))
  
  # create the extra table information switch (if and only if we have borrowing turned on)
  
  output$borrowing_hyper_parameters <- renderUI(
    if (reactive_borrowing()){
    column(width=col_width,
           numericInput("a1",HTML("a<sub>1</sub>"),2,min = 1,max = 20,step = 1,width = NULL),
           numericInput("b1",HTML("b<sub>1</sub>"),2,min = 1,max = 20,step = 1,width = NULL),
           numericInput("a2",HTML("a<sub>2</sub>"),54,min = 1,max = 1000,step = 1,width = NULL),
           numericInput("b2",HTML("b<sub>2</sub>"),3,min = 1,max = 20,step = 1,width = NULL)
  )})
  
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
    choices = c("Moderate", "Strong"),
    selected = "Moderate"
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
  
  # Get level of borrowing
  reactive_wiq_scalar <- 
    reactive({
      req(input$LoB) # we need a value of LoB
      if (input$LoB == 'Moderate'){0.3}
      else if (input$LoB == 'Strong'){0.1}
      else{'unknown'}
    })

  ### Now need to calculate results and draw the table. (in development)
  
  reactive_n <- reactive({
    if(!reactive_borrowing()) {
      req(is.numeric(r_vect()))
      NoBrwNi(sigma_vect(),r_vect(),input$eta,input$zeta,input$delta,input$ssq)
    }
    else{
      nlm(MyBrwfun,
             p=r_vect()*150, # default value is not important 
             Ri = r_vect(),
             sig02 = sigma_vect(),
             s02 = input$ssq,
             wiq=array(reactive_wiq_scalar(), dim = c(reactive_K(), reactive_K())),
             cctrpar = 0.1,
             dw=c(input$a1,input$b1),
             br=c(input$a2,input$b2),
             targEff=input$delta,
             eta = input$eta,
             zeta = input$zeta)$estimate}
    })
  
  make_short_table <- reactive({
  if(!reactive_borrowing())
  {TRUE}
  else
    {
    req(!is.null(input$debug)) # we need a value of debug
    if (input$debug)
        {TRUE}
    else
        {FALSE}
    }
  })
  
  output$table <- renderUI(
    # short version bool creation needed as input is undefined for the no borrowing case
   
    if (make_short_table()){ 
                          renderTable(data.frame('k'=1:reactive_K(),
                         '\u03C3<sub>k</sub>'=sigma_vect(),
                         'n<sub>R</sub>' = as.integer(ceiling(reactive_n()*r_vect()) + ceiling(reactive_n()*(1-r_vect()))),
                         'n<sub>T</sub>'=as.integer(ceiling(reactive_n()*r_vect())),
                         'n<sub>C</sub>'=as.integer(ceiling(reactive_n()*(1-r_vect()))),
                         check.names=FALSE),
              sanitize.colnames.function = function(x) x)
      }
    else{
      # long version
      renderTable(data.frame('k'=1:reactive_K(),
                             '\u03C3<sub>k</sub>'=sigma_vect(),
                             'n float'= reactive_n(),
                             'n<sub>R</sub>' = as.integer(ceiling(reactive_n()*r_vect()) + ceiling(reactive_n()*(1-r_vect()))),
                             'n<sub>T</sub>'=as.integer(ceiling(reactive_n()*r_vect())),
                             'n<sub>C</sub>'=as.integer(ceiling(reactive_n()*(1-r_vect()))),
                             'Inequality Values' = MyBrwfunVect(reactive_n(),
                                                                Ri = r_vect(),
                                                                sig02 = sigma_vect(),
                                                                s02 = input$ssq,
                                                                wiq=array(reactive_wiq_scalar(), dim = c(reactive_K(), reactive_K())), 
                                                                cctrpar = 0.1,
                                                                dw=c(input$a1,input$b1),
                                                                br=c(input$a2,input$b2),
                                                                targEff=input$delta,
                                                                eta = input$eta,
                                                                zeta = input$zeta),
                             'Inequality Values (with ints)' = MyBrwfunVect(ceiling(reactive_n()*r_vect()) + ceiling(reactive_n()*(1-r_vect())),
                                                                            Ri = r_vect(),
                                                                            sig02 = sigma_vect(),
                                                                            s02 = input$ssq,
                                                                            wiq=array(reactive_wiq_scalar(), dim = c(reactive_K(), reactive_K())), 
                                                                            cctrpar = 0.1,
                                                                            dw=c(input$a1,input$b1),
                                                                            br=c(input$a2,input$b2),
                                                                            targEff=input$delta,
                                                                            eta = input$eta,
                                                                            zeta = input$zeta),
                             check.names=FALSE),
                  sanitize.colnames.function = function(x) x)
      }
     
    )
  
}
