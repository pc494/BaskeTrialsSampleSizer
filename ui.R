library(shiny)
library(shinyWidgets)
col_width <- 3
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
                        numericInput("eta","\u03B7",0.95,min = 0,max = 5,step = 0.05,width = NULL),
                        numericInput("zeta","	\u03B6",0.8,min = 0,max = 5,step = 0.05,width = NULL)
                        ),
                  column(width=col_width,uiOutput('variance')),
                  column(width=col_width,uiOutput('allocratio')),
                  column(width=col_width),
                  ),
          #checkboxInput("use_equal_alloc_ratio_bool", "Use Equal Allocation Ratios", TRUE),
          materialSwitch(inputId = "use_equal_alloc_ratio_bool", label = "Use Equal Allocation Ratios (False/True)", value=TRUE ,status = "default"),
          sliderTextInput(
            inputId = "mySliderText",
            label = "Level of Borrowing",
            grid = FALSE,
            force_edges = TRUE,
            choices = c("None",
                        "Low", "High")
          ),
          actionButton("update" ,"Calculate", icon("refresh"),
                       class = "btn btn-primary"),
          textOutput("value")
          )
