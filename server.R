#Project
library(shiny)
library(quantmod)
#library(TSA)
#library(VGAM)
#library(RODBC)

# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  ## Acquiring data
  
  ### Get stock symbol  
  dataInput <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      getSymbols(input$symb, src = "yahoo", auto.assign = FALSE)
    }))
  })
  
  ### Get stock date range    
  datesInput <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      paste0(input$dates[1], "::",  input$dates[2])
    }))
  })
  
  returns <- reactive({ 
    if (input$get == 0)
      return(NULL)
    
    dailyReturn(dataInput())
  })
  
  xs <- reactive({ 
    if (input$get == 0)
      return(NULL)
    
    span <- range(returns())
    seq(span[1], span[2], by = diff(span) / 100)
  })
  
  # tab based controls
  output$newBox <- renderUI({
    switch(input$tab,
           "Charts" = chartControls,
           "Model" = modelControls,
           "VaR" = helpText("VaR")
    )
  })
  
  # Charts tab
  chartControls <- div(
    wellPanel(
      selectInput("chart_type",
                  label = "Chart type",
                  choices = c("Candlestick" = "candlesticks", 
                              "Matchstick" = "matchsticks",
                              "Bar" = "bars",
                              "Line" = "line"),
                  selected = "Line"
      ),
      checkboxInput(inputId = "log_y", label = "log y-axis", 
                    value = FALSE)
    ),
    
    wellPanel(
      p(strong("Analysis")),
      checkboxInput("ta_vol", label = "Volume", value = FALSE),
      checkboxInput("ta_sma", label = "Simple Moving Average", 
                    value = FALSE),
      checkboxInput("ta_ema", label = "Exponential Moving Average", 
                    value = FALSE),
      checkboxInput("ta_wma", label = "Weighted Moving Average", 
                    value = FALSE),
      checkboxInput("ta_bb", label = "Bollinger Bands", 
                    value = FALSE),
      checkboxInput("ta_momentum", label = "Momentum", 
                    value = FALSE),
      
      br(),
      
      actionButton("chart_act", "Click to Add Analysis")
    )
  )
  
  TAInput <- reactive({
    if (input$chart_act == 0)
      return("NULL")
    
    tas <- isolate({c(input$ta_vol, input$ta_sma, input$ta_ema, 
                      input$ta_wma,input$ta_bb, input$ta_momentum)})
    funcs <- c(addVo(), addSMA(), addEMA(), addWMA(), 
               addBBands(), addMomentum())
    
    if (any(tas)) funcs[tas]
    else "NULL"
  })
  
  output$chart <- renderPlot({
    chartSeries(dataInput(),
                name = input$symb,
                type = input$chart_type,
                subset = datesInput(),
                log.scale = input$log_y,
                theme = "white",
                TA = TAInput())
  })
  
})