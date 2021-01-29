library(shiny)
library(feather)
library(DT)
library(tidyverse)

## Test data
library(ggplot2)

## Setam doar local
#  setwd("E:/..FMI-UniBuc/2nd/S1/PS/tutorials/PokerStatsApp")

data <- read_feather("data/mpg.feather")

benfIndex <- read_feather("data/benford/benford_index.feather")
outBankIndex <- read_feather("data/outcomes/outcomes_and_bankrolls.feather")

getOutBankPlotOb <- function(p_name, param) {
  readRDS(paste("data/outcomes/", as.character(outBankIndex[outBankIndex$p_name==p_name, param][[param]]), sep =""))
}

getBenfPlotOb <- function(var_name, digits) {
  readRDS(paste("data/benford/",as.character(benfIndex[benfIndex$var_name == var_name & benfIndex$digits == digits,]$filename), sep=""))
}


## PC-ul meu nu duce, dar csf 
#data <- read_feather("data/all_hands.feather")

server <- function(input, output, session) {
  observe({
    brandName <- input$brand
    val <- length(data$manufacturer[data$manufacturer == brandName])
    updateSliderInput(session, "nrCars", value = floor(val/2),
                      min = 1, max = val, step = 1)
  })
  
  
  output$dataTable <- renderDataTable(datatable({
    if (input$man != "All") {
      data <- data[data$manufacturer == input$man,]
    }
    if (input$cyl != "All") {
      data <- data[data$cyl == input$cyl,]
    }
    if (input$trans != "All") {
      data <- data[data$trans == input$trans,]
    }
    data
  }))
  
  output$bankrollPlot <- renderPlot({
    replayPlot(getOutBankPlotOb(input$bankrollPlayer, "bankroll_file"))
  })
  
  output$benfordPlot <- renderPlot({
    plot(getBenfPlotOb(input$benfordVar, input$benfordDigits))
  })
  
  output$outcomePlot <- renderPlot({
    replayPlot(getOutBankPlotOb(input$outcomePlayer, input$outcomeHands))
  })
  
}