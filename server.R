###########
##Project##
###########

library(shiny)
library(quantmod)

# Libraries for new functionalities 
# to be added in the future
#library(TSA)
#library(VGAM)
#library(dplyr)
#library(ggplot2)
#library(RODBC)


shinyServer(function(input, output) {
  
  ## Acquiring data
  
  ### Get stock symbol
  data.input <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      getSymbols(input$symb, src = "yahoo", auto.assign = F)
    }))
  })
  
  ### Get date range
  date.input <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      paste0(input$dates[1], "::",  input$dates[2])
    }))
  })
  

  # Tab based controls
  output$newBox <- renderUI({
    switch(input$tab,
           "Charts" = chartControls
    )
  })
  
  # Define chart tabs
  chartControls <- div(
    wellPanel(
      selectInput("chart_type",
                  label = "Chart type",
                  choices = c("Line" = "line",
                              "Candlestick" = "candlesticks", 
                              "Matchstick" = "matchsticks",
                              "Bar" = "bars"),
                  selected = "Line"
      ),
      checkboxInput(inputId = "log_y", label = "log y-axis", 
                    value = FALSE)
    ),

    # Define add-in analytics functions   
    wellPanel(
      p(strong("Analysis")),
      checkboxInput("ta_vol", 
                    label = "Volume", 
                    value = FALSE),
      checkboxInput("ta_sma", 
                    label = "Simple Moving Average", 
                    value = FALSE),
      checkboxInput("ta_ema", 
                    label = "Exponential Moving Average", 
                    value = FALSE),
      checkboxInput("ta_wma", 
                    label = "Weighted Moving Average", 
                    value = FALSE),
      checkboxInput("ta_bb", 
                    label = "Bollinger Bands", 
                    value = FALSE),
      checkboxInput("ta_momentum", 
                    label = "Momentum", 
                    value = FALSE),
      
      br(),
      
      actionButton("chart_action", "Click to Add Analysis")
    )
  )

  # Define reactive function that reads in user's actions 
  analysis.input <- reactive({
    if (input$chart_action == 0)
      return("NULL")
    
    analysis <- isolate({c(input$ta_vol, input$ta_sma, input$ta_ema, 
                      input$ta_wma,input$ta_bb, input$ta_momentum)})
    add.analysis <- c(addVo(), addSMA(), addEMA(), addWMA(), 
               addBBands(), addMomentum())
    
    if (any(analysis)) add.analysis[analysis]
    else "NULL"
  })
  
  # Define chart output type
  output$chart <- renderPlot({
    chartSeries(data.input(),
                name = input$symb,
                type = input$chart_type,
                subset = date.input(),
                log.scale = input$log_y,
                theme = "white",
                TA = analysis.input())
  })
  
})