fluidPage(
  fluidRow(
    column(width=3,
          numericInput("K",
                       "Number of Trials",
                        5,min = 1,max = 1000,step = 1,width = NULL)
          ),
    column(width=3,
           uiOutput('var')
          )
          )
)
  