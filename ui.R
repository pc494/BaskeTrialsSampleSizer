fluidPage(
          fluidRow(
                  column(width=3,
                        numericInput("K","Number of Trials",5,min = 1,max = 20,step = 1,width = NULL)),
                  column(width=3,
                        numericInput("ssq","ssquared",100,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("a1","asub1",2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("b1","bsub1",2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("a2","asub2",54,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("b2","bsub2",3,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("eta","eta",0.95,min = 0,max = 5,step = 1,width = NULL),
                        numericInput("zeta","zeta",0.8,min = 0,max = 5,step = 1,width = NULL)
                        ),
                  column(width=3,uiOutput('variance')),
                  column(width=3,uiOutput('allocratio'))
                  )
          )
  