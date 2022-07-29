source("subfun_and_simulators.R")

### OLDCODE: Button to display inputs ####
#output$value <- renderText({
#  input$update
#  s = 2 * input$K
#  isolate(paste0("K = ",s,", the value of eta is: ", input$eta, " and " , input$use_equal_alloc_ratio_bool))
#})

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
                        {0.5}
                    else {
                        sapply(1:reactive_K(), function(i) {input[[paste0("R_", i)]]})}
  })
  
  # write out all the hyper-parameter selections
  
  output$desc <- renderText(paste0("Results calculated with \u03B4=",input$delta,", \u03B7=",input$eta,', \u03B6=',input$zeta))
  
  reactive_implemented_bool <- reactive({input$LoB == 'No'})
  
  # perform calculations 
  
      reactive_n <- reactive({
        if (reactive_implemented_bool())
        {
         NoBrwNi(sigma_vect(),r_vect(),input$eta,input$zeta,input$delta,input$ssq)
        }
      else{
        break #so it doesn't throw an error
        reactive_n <- MyBrwfun(MyNi, 
                               Ri = r_vect(),
                               sig02 = sigma_vect(),
                               s02 = input$ssq,
                               wiq,
                               cctrpar = 0.1,
                               dw,
                               br,
                               targEff=input$delta,
                               eta = input$eta,
                               zeta = input$zeta)
      }
      })
    # Render Output Table 
  
    output$value <- renderUI(
      if (reactive_implemented_bool())
      { renderTable(data.frame('k'=1:input$K,
                               '\u03C3<sub>k</sub>'=sigma_vect(),
                               'n<sub>R</sub>' = as.integer(reactive_n()+0.5),
                               'n<sub>T</sub>'=as.integer(reactive_n()*r_vect()+0.5),
                               'n<sub>C</sub>'=as.integer(reactive_n()*(1-r_vect())+0.5),
                               check.names=FALSE),
                               sanitize.colnames.function = function(x) x)
      }
      else{renderText('Currently in development')}
     )
  
}
