fluidPage(
  numericInput(
    "K",
    "Number of Trials",
    5,
    min = 1,
    max = 1000,
    step = 1,
    width = NULL
  ),
  sliderInput("Figure_Number",
              label = "Figure Number",
              min = 1,
              max = 5,
              value = 1),
  plotOutput("curve_plot")
)