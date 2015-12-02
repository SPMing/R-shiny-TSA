###########
##Project##
###########

library(shiny)


# Define UI 
shinyUI(pageWithSidebar(
  
  headerPanel("Stock Scanner"),
  
  sidebarPanel(
    
    helpText("Select a stock and information will be collected from yahoo finance."),
    
    textInput("symb", "Stock Symbol", "aapl"),
    
    dateRangeInput("dates", 
                   "Start-Date to End-Date",
                   start = "2011-01-01", end = "2014-09-05"),
    
    actionButton("get", "Click to Pull Stock Data"),
    
    br(),
    br(),
    
    uiOutput("newBox")
    
  ),
  
  # Result of plot, with add-on functionality
  mainPanel(
    tabsetPanel(
      tabPanel("Charts", plotOutput("chart")), 
      id = "tab"
    )
  )
))