library(shiny)
library(tsibbledata)
library(ggplot2)

shinyServer(function(input, output){
  pigs <- aus_livestock[aus_livestock$Animal == "Pigs", ]
  my_ts <- pigs[pigs$State == "Queensland", ]
  lambda <- my_ts %>% 
    features(Count, features = guerrero) %>%
    pull(lambda_guerrero)
  
  
  output$graph <- renderPlot(
    if (input$graph == 'Seasonal') {
      gg_season(my_ts)
    }else if (input$graph == 'Autocorrelation') {
       autoplot(ACF(my_ts))
    }else if (input$graph == 'Decomposition'){
      my_ts %>% model(X_13ARIMA_SEATS(Count ~ seats())) %>% components() %>% autoplot()
    }
)
  output$text <- renderText (
    if (input$graph == 'Seasonal') {
      paste("There are higher counts of pigs in February to May. Lower peaks are September to January.")
    }else if (input$graph == 'Autocorrelation') {
      paste("Every 3rd bar, we see a peak in the data, proving seasonality. Using yesterday's data is a strong indicator and the p-values are all significant for this chart.")
    } else if (input$graph == 'Decomposition'){
      paste("Trend: Every 10 years, we see a 2000 unit increase in the count of pigs. Season: Every 4 years, we see a sharp decline, and almost immediate rebound a month (or so) later.")
    }
  )
output$my_ts <- renderPlot(
  autoplot(my_ts)
)
output$time_series <- renderText(
  paste("This time series shows the count of pigs in Queensland, AUS from 1980 to the end of 2018.")
)
output$add_fe <- renderPlot(
  my_ts %>%
    autoplot(box_cox(Count, lambda))
)
output$interp <- renderText(
  paste("This Box Cox graph represents the transformed count of Animals across Australia over time. Although any transformation on the count does not appear to be meaningful, it is the only non-date data I have for this set. I did notice, however, it greatly decreased the y-axis. There is still strong seasonality in this series, with peaks in the early Spring months and valleys in the later Fall months.")
)
})
  

    