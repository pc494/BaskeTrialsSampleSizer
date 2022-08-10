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
          # for visual clarity we use an inversion on our switches
          materialSwitch(inputId = "use_equal_alloc_ratio_bool", label = "Use Equal Allocation Ratios (True/False)", value=FALSE ,status = "default"),
          materialSwitch(inputId = "borrowing", label = "Are you using borrowing? (True/False)", value=TRUE ,status = "default"),
          # only if borrowing
          uiOutput("extra_table_switch"),
          uiOutput("borrowing_slider"),
          # always
          tableOutput("table"),
          uiOutput("desc")
)