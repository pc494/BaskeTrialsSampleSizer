source("subfun_and_simulators.R")

function(input, output, session){
  epsilon <- 0.05
  
  ### Sigma List ###
  output$variance <- renderUI({
    num <- as.integer(input$K)
    
    lapply(1:num, function(i) {
      numericInput(paste0("var_", i), label = HTML(paste0('\u03C3<sub>',i,'</sub>')), value = 10)
    })
  })
  ### R list ###
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
  
  # Get character vectors for R and sigma 
  reactive_K <- reactive({input$K})
  sigma_vect <- reactive({sapply(1:reactive_K(), function(i) {input[[paste0("var_", i)]]})})
  
  r_vect <- reactive({if (!reactive_use_equal_alloc_ratio())
                        {replicate(input$K,0.5)} #full vector of 50% allocations
                    else {
                        sapply(1:reactive_K(), function(i) {input[[paste0("R_", i)]]})}
  })
  
  # write out all the hyper-parameter selections
  
  output$desc <- renderText(paste0("Results calculated with \u03B4=",input$delta,", \u03B7=",input$eta,', \u03B6=',input$zeta))
  borrowing <- reactive({input$borrowing})
  ### Clear all non-borrowing 
  if (!borrowing()){
  reactive_n <- reactive({NoBrwNi(sigma_vect(),r_vect(),input$eta,input$zeta,input$delta,input$ssq)})
  
  output$value <- renderTable(data.frame('k'=1:reactive_K(),
                         '\u03C3<sub>k</sub>'=sigma_vect(),
                         'n<sub>R</sub>' = as.integer(ceiling(reactive_n())),
                         'n<sub>T</sub>'=as.integer(reactive_n()*r_vect()+0.5),
                         'n<sub>C</sub>'=as.integer(reactive_n()*(1-r_vect())+0.5),
                         check.names=FALSE),
              sanitize.colnames.function = function(x) x)
  }
  
  if (borrowing()){
  reactive_LoB <- reactive({input$LoB})
  reactive_wiq_scalar <- reactive({if (reactive_LoB() == 'Moderate'){0.3}
                                  else if (reactive_LoB() == 'Strong'){0.1}
            })
  # perform calculations 
  
      reactive_n <- reactive({ 
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
              zeta = input$zeta)$estimate})
      
      
    # Render Output Table 
    
    # add a debug switch here
    debug <- reactive({input$debug})
    
    output$value <- if (debug()) {
      renderTable(data.frame('k'=1:reactive_K(),
                               '\u03C3<sub>k</sub>'=sigma_vect(),
                               'n float'= reactive_n(),
                               'n<sub>R</sub>' = as.integer(ceiling(reactive_n())),
                               'n<sub>T</sub>'=as.integer(reactive_n()*r_vect()+0.5),
                               'n<sub>C</sub>'=as.integer(reactive_n()*(1-r_vect())+0.5),
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
                            'Inequality Values (with ints)' = MyBrwfunVect(as.integer(ceiling(reactive_n())),
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
    else{
      renderTable(data.frame('k'=1:reactive_K(),
                             '\u03C3<sub>k</sub>'=sigma_vect(),
                             'n<sub>R</sub>' = as.integer(ceiling(reactive_n())),
                             'n<sub>T</sub>'=as.integer(reactive_n()*r_vect()+0.5),
                             'n<sub>C</sub>'=as.integer(reactive_n()*(1-r_vect())+0.5),
                             check.names=FALSE),
                             sanitize.colnames.function = function(x) x)
      
      
    }}
}
