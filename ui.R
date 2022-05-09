fluidPage(
          fluidRow(
                  column(width=3,
                        numericInput("K","Number of Trials",5,min = 1,max = 20,step = 1,width = NULL)),
                  column(width=3,
                        numericInput("ssq","s²",100,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("a1","a₁",2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("b1","b₁",2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("a2","a₂",54,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("b2","b₂",3,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("eta","\u03B7",0.95,min = 0,max = 5,step = 1,width = NULL),
                        numericInput("zeta","	\u03B6",0.8,min = 0,max = 5,step = 1,width = NULL)
                        ),
                  column(width=3,uiOutput('variance')),
                  column(width=3,uiOutput('allocratio'))
                  )
          )
  