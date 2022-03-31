function(input, output, session){
  output$curve_plot <- renderPlot({
    curve(x^input$Figure_Number, from = -5, to = 5)
  })
}