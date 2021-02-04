library(shiny)
library(feather)
library(DT)
library(tidyverse)

## Test data
library(ggplot2)

## Setam doar local
#  setwd("E:/..FMI-UniBuc/2nd/S1/PS/tutorials/PokerStatsApp")


benfIndex <- read_feather("data/benford/benford_index.feather")
outBankIndex <- read_feather("data/outcomes/outcomes_and_bankrolls.feather")
topHandsIndex <- read_feather("data/top_hands/top_hands_index.feather")
ruinIndex <- read_feather("data/ruin/ruin_index.feather")



getOutBankPlotOb <- function(p_name, param) {
  readRDS(paste("data/outcomes/", as.character(outBankIndex[outBankIndex$p_name==p_name, param][[param]]), sep =""))
}

getBenfPlotOb <- function(var_name, digits) {
  readRDS(paste("data/benford/",as.character(benfIndex[benfIndex$var_name == var_name & benfIndex$digits == digits,]$filename), sep=""))
}

getTopHandsPlotOb <- function(p_name, hands) {
  readRDS(paste("data/top_hands/",as.character(topHandsIndex[topHandsIndex$p_name == p_name & topHandsIndex$hands == hands,]$filename), sep=""))
}

getRuinTable <- function(p_name) {
  readRDS(paste("data/ruin/",as.character(ruinIndex[ruinIndex$p_name == p_name,]$filename), sep=""))
}


## PC-ul meu nu duce, dar csf 
#data <- read_feather("data/all_hands.feather")

server <- function(input, output, session) {
  output$bankrollPlot <- renderPlot({
    replayPlot(getOutBankPlotOb(input$bankrollPlayer, "bankroll_file"))
  })
  
  output$topHandsPlot <- renderPlot({
    replayPlot(getTopHandsPlotOb(input$tophandsPlayer, input$tophandsHands))
  })
  
  output$benfordPlot <- renderPlot({
    plot(getBenfPlotOb(input$benfordVar, input$benfordDigits))
  })
  
  output$outcomePlot <- renderPlot({
    replayPlot(getOutBankPlotOb(input$outcomePlayer, input$outcomeHands))
  })
  
  output$ruinTable <- renderTable({getRuinTable(input$ruinPlayer)}, 
                                  striped=TRUE,
                                  hover=TRUE,
                                  bordered=TRUE,
                                  digits = 4)
}