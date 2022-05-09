col_width <- 2
fluidPage(
          fluidRow(
                  column(width=col_width,
                        numericInput("K","Number of Trials",5,min = 1,max = 20,step = 1,width = NULL)),
                  column(width=col_width,
                        numericInput("ssq","s_{0k}²",100,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("a1","a₁",2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("b1","b₁",2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("a2","a₂",54,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("b2","b₂",3,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("eta","\u03B7",0.95,min = 0,max = 5,step = 1,width = NULL),
                        numericInput("zeta","	\u03B6",0.8,min = 0,max = 5,step = 1,width = NULL)
                        ),
                  column(width=col_width,uiOutput('variance')),
                  column(width=col_width,uiOutput('allocratio'))
                  )
          )
  