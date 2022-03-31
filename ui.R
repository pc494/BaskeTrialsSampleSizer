fluidPage(
  # fluidRow(
  #   box(width = 12, title = "A Box in a Fluid Row I want to Split", 
  #       splitLayout(
  #         textInput("inputA", "The first input"),
  #         textInput("inputB", "The second input"),
  #         textInput("inputC", "The third input")
  #                 )
  #       )
  #   ),
  numericInput(
    "K",
    "Number of Trials",
    5,
    min = 1,
    max = 1000,
    step = 1,
    width = NULL
  ))
  # sliderInput("Figure_Number",
  #             label = "Figure Number",
  #             min = 1,
  #             max = 5,
  #             value = 1),
  # plotOutput("curve_plot")

