library(shiny)
library(shinythemes)
library(DT)
library(benford.analysis)
library(feather)

data <- read_feather("data/mpg.feather")
outBankIndex <- read_feather("data/outcomes/outcomes_and_bankrolls.feather")

ui <- bootstrapPage(title = "PokerStats", 
      tags$head(
        tags$link(rel="preconnect", href="https://fonts.gstatic.com"),
        tags$link(rel="shortcut icon", href="images/favicon.ico"),
        tags$link(rel="stylesheet", href="https://fonts.googleapis.com/css2?family=Russo+One&display=swap"),
        tags$link(rel="stylesheet", type="text/css", href="styles/site.css")
      ),
  navbarPage(title=div(class="nav--titlebox", img(class="logo", src="images/logo.png"), span(class="nav--title__font","PokerStats")), theme= shinytheme("flatly"),
  
             tabPanel("Data",
         wellPanel(
         fluidRow(
           
           column(4,
                  selectInput("man",
                              "Manufacturer:",
                              c("All",
                                unique(as.character(data$manufacturer))))
           ),
           column(4,
                  selectInput("trans",
                              "Transmission:",
                              c("All",
                                unique(as.character(data$trans))))
           ),
           column(4,
                  selectInput("cyl",
                              "Cylinders:",
                              c("All",
                                unique(as.character(data$cyl))))
           )
          )
         ),
         # Create a new row for the table.
         dataTableOutput("dataTable")),
navbarMenu("Stats",
tabPanel("Bankrolls",
         sidebarLayout(
           sidebarPanel(
             selectInput("bankrollPlayer","Select palyer:",
                         outBankIndex$p_name),
            ),
           mainPanel(
             plotOutput("bankrollPlot")
           )
          ),
        ),
tabPanel("Top wins"),
tabPanel("Showdowns"),
tabPanel("Benford law",
         sidebarLayout(
           sidebarPanel(
             radioButtons("benfordVar", "Select variable:",
                          c("Winnings" = "win_",
                            "Pot size" = "pot_size",
                            "Bankrolls" = "bankroll")),
             sliderInput(inputId = "benfordDigits",
                         label = "Number of digits:",
                         min = 1,
                         max = 3,
                         value = 1,
                         step = 1)
           ),
           mainPanel(
             plotOutput("benfordPlot")
           )
         ),
         ),
tabPanel("Outcome comparison",
         sidebarLayout(
             sidebarPanel(
               selectInput("outcomePlayer","Select palyer:",
                           outBankIndex$p_name),
             radioButtons("outcomeHands", "Number of hands:",
                          c("100" = "dist1e2_file",
                            "1.000" = "dist1e3_file",
                            "10.000" = "dist1e4_file")),
            ),
           mainPanel(
             plotOutput("outcomePlot")
           )
         )
        ),
tabPanel("Will you be ruined?"))))
    