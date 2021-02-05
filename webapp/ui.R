library(shiny)
library(shinythemes)
library(DT)
library(benford.analysis)
library(feather)

outBankIndex <- read_feather("data/outcomes/outcomes_and_bankrolls.feather")
topHandsIndex <- read_feather("data/top_hands/top_hands_index.feather")
ruinIndex <- read_feather("data/ruin/ruin_index.feather")


ui <- bootstrapPage(title = "PokerStats", 
      tags$head(
        tags$link(rel="preconnect", href="https://fonts.gstatic.com"),
        tags$link(rel="shortcut icon", href="images/favicon.ico"),
        tags$link(rel="stylesheet", href="https://fonts.googleapis.com/css2?family=Russo+One&display=swap"),
        tags$link(rel="stylesheet", href="https://fonts.googleapis.com/css2?family=Play:wght@700&display=swap"),
        tags$link(rel="stylesheet", type="text/css", href="styles/site.css"),
        tags$script(src="scripts/site.js")
      ),
  navbarPage(title=div(class="nav--titlebox", img(class="logo", src="images/logo.png"), span(class="nav--title__font","PokerStats")), theme= shinytheme("flatly"),
             tabPanel("About",
             tags$div(class="background-container", 
                      div(class="background--image")
                      ),
             tags$h1(class="title text__col-white text__al-center", "Welcome to PokerStats"),
             tags$div(class="main-container",
                      p(class="text__col-white text__al-center main--description",
                        "This site intends to present another perspective of poker.",tags$br()," Feel free to check our statistics right above !"),
                      p(class="text__col-white text__al-center",
                        "For more details surf on ",a("source code.", href="https://github.com/IancuOnescu/poker-stats")),
                      div(class="team-container",
                        p(class="team-intro text__col-white text__al-center", "Our team"),
                        div(class="cardboard-container",
                            div(class="card",
                                div(class="card--image-shape",
                                    img(class="image-shape--image",src="https://avatars.githubusercontent.com/u/50520077?s=400&u=92cf194a6844b8da4cde82c8838af9bbc967a152&v=4")),
                                div(class="card--body",
                                    tags$a(class="text__col-white text__al-center link", href="https://github.com/Seras3", "Seras3"))),
                            div(class="card", 
                                div(class="card--image-shape",
                                    img(class="image-shape--image",src="https://avatars.githubusercontent.com/u/10727813?s=400&u=e7bfe666b7d81b57c53aa1353bc0a34e24cc2475&v=4")),
                                div(class="card--body",
                                    tags$a(class="text__col-white text__al-center link", href="https://github.com/JustBeYou", "JustBeYou"))),
                            div(class="card",
                                div(class="card--image-shape",
                                    img(class="image-shape--image",src="https://avatars.githubusercontent.com/u/22654524?s=400&v=4")),
                                div(class="card--body",
                                    tags$a(class="text__col-white text__al-center link", href="https://github.com/IancuOnescu", "IancuOnescu")))
                            
                        )
                        )
                       )
            ),
navbarMenu("Stats",
tabPanel("Bankrolls",
         sidebarLayout(
           sidebarPanel(
             selectInput("bankrollPlayer","Select palyer:",
                         outBankIndex$p_name),
             tags$label("Summary:"),
             tags$p("The bankroll represents player's available money. 
                    It is the main pivot in relation to which the reliability of certain strategies can be analyzed."),
             tags$br(),
             tags$label("Plot says:"),
             tags$p("How much money did a player have at one point in time.")
            ),
           mainPanel(
             plotOutput("bankrollPlot")
           )
          ),
        ),
tabPanel("Top winnings",
         sidebarLayout(
           sidebarPanel(
             selectInput("tophandsPlayer","Select palyer:",
                         topHandsIndex$p_name, selected=1),
             radioButtons("tophandsHands", "Select top:",
                          c("5" = "5",
                            "10" = "10",
                            "15" = "15")),
             tags$label("Summary:"),
             tags$p("Each player has his own lucky hands, but when it comes to statistics there is no room for denial. 
                    The safest hands are the ones in which a player wins the most frequently."),
             tags$br(),
             tags$label("Plot says:"),
             tags$p("Top N winning hands and what percentage a hand took in this top ordered by frequency.")
           ),
           mainPanel(
             plotOutput("topHandsPlot")
           )
         ),
        ),
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
                         step = 1),
             tags$label("Summary:"),
             tags$p("Similar to the usage of Normal distribution as a tool for reference and gold standard, this law can be utilized to detect pattern in naturally occurring datasets.
                    This can lead to important applications in data science such as catching anomalies or fraud detection."),
             tags$br(),
             tags$label("Plot says:"),
             tags$p("If data set converges to Benford's Law path, then it respects a natural pattern. 
                    As you can see, bankrolls respect nature's laws, besides to pot size which depends on some fixed pot numbers.")
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
             tags$label("Summary:"),
             tags$p("The central idea was to see if the distribution of a player's winnings could be approximated by a", span("Gaussian", style="font-weight:bold;"),"curve. In itself, the distribution of the probabilities of poker matches is discreet, not continuous, but the", span("Central Boundary Theorem", style="font-weight:bold;"), "tells us that using enough hands in the end we will reach the desired result."),
             tags$br(),
             tags$label("Plot says:"),
             tags$p("If the wave fall in right side of 0, the player has a good strategy.")
            ),
           mainPanel(
             plotOutput("outcomePlot")
           )
         )
        ),
tabPanel("Will you be ruined?",
         sidebarLayout(
           sidebarPanel(
             selectInput("ruinPlayer","Select palyer:",
                         ruinIndex$p_name),
             tags$label("Summary:"),
             tags$p("We also aimed to analyze the risk of a player becoming bankrupt, thus preventing him from projecting his gains with the help of the Gaussian curve."),
             tags$br(),
             tags$label("Table says:"),
             tags$p("If the bankroll size is bigger than the risk of ruin will be reduced.")
           ),
           mainPanel(
             tableOutput("ruinTable")
           )
         )
))))
    