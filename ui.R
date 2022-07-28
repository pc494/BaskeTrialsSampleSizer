library(shiny)
library(shinyWidgets)
source("subfun_and_simulators.R")

col_width <- 2
fluidPage(
          fluidRow(
                  column(width=col_width,
                        numericInput("K","# of Trials",5,min = 1,max = 20,step = 1,width = NULL)),
                  column(width=col_width,
                        numericInput("ssq",HTML('s<sup>2</sup><sub>0k</sub>'),100,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("a1",HTML("a<sub>1</sub>"),2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("b1",HTML("b<sub>1</sub>"),2,min = 1,max = 20,step = 1,width = NULL),
                        numericInput("a2",HTML("a<sub>2</sub>"),54,min = 1,max = 1000,step = 1,width = NULL),
                        numericInput("b2",HTML("b<sub>2</sub>"),3,min = 1,max = 20,step = 1,width = NULL)
                        ),
                  column(width=col_width,
                        numericInput("eta","\u03B7",0.95,min = 0,max = 5,step = 0.05,width = NULL),
                        numericInput("zeta","	\u03B6",0.8,min = 0,max = 5,step = 0.05,width = NULL),
                        numericInput("delta","	\u03B4",0.8,min = 0,max = 1,step = 0.05,width = NULL),
                        ),
                  column(width=col_width,uiOutput('variance')),
                  column(width=col_width,uiOutput('allocratio')),
                  column(width=col_width),
                  ),
          materialSwitch(inputId = "use_equal_alloc_ratio_bool", label = "Use Equal Allocation Ratios (True/False)", value=FALSE ,status = "default"),
          sliderTextInput(
            inputId = "LoB",
            label = "Level of Borrowing",
            grid = FALSE,
            force_edges = TRUE,
            choices = c("No",
                        "Moderate", "Strong")
          ),
          #actionButton("update" ,"Calculate", icon("refresh"),
          #             class = "btn btn-primary"),
          uiOutput("value"),
          uiOutput("desc")
          )
