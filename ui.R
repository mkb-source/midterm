library(fpp3)
library(shiny)
library(shinythemes)
data("aus_livestock")


shinyUI(fluidPage(
  h3("Welcome. This app maps out the count of pigs in Queensland Australia from 1976 to the end of 2018. The full time series is the graph below the interpretations, and you may select which transformed graph to view from the drop-down box below."),
  theme = shinytheme("cerulean"),
    titlePanel("Australian Livestock"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
      inputId = "graph",
      label = "Choose a graph to view",
      choices = list("Seasonal", "Autocorrelation", "Decomposition"))
                 
      ),
        
        mainPanel(
          
          h3("Time Series Transformations"
          ),
          plotOutput("graph"),
          textOutput("text"),
          
          br(),
          h3("Full Time Series"),
          plotOutput("my_ts"),
          textOutput("time_series"),
          
          br(),
          
          h3("Box-Cox Transformation"),
          plotOutput("add_fe"),
          textOutput("interp")
        )
)
)
)
