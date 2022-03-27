#tracker-app
library(shiny)
library(bslib)
library(tidyverse)

ui <- navbarPage(
  theme = bs_theme(
    bg = "#FFFFFF", #white
    fg = "#141115", #Xiketic
    primary = "#4D6A6D", #Deep Space Sparkle
    secondary = "#4C2B36", #Old Mauve
    base_font = "Segoe UI"
  ),
  
  title = tags$div(img(src = "JAM-logos-colour-adj-crop.jpg", height = 75), title = "Tracker App"),
  position = "static-top",

  
  tabPanel(title = "Data Input",
           fluidRow(
             column(
               width = 3,
               tags$p("Input your data by selecting a Category on the drowpdown and 
                  filling in the text field."),
               actionButton(inputId = "trackButton", label = "Track Instance")
             ),
             mainPanel()
           )
  ),
  
  tabPanel(title = "Analysis", value = "analysis"),
  tabPanel(
    title = "Settings",
    value = "settings",
    sidebarLayout(
      sidebarPanel(
        tags$p("Specify your settings for the App")
      ),
      mainPanel(
        textInput(
          inputId = "location",
          label = "Select a location to save your data"
        ),
        textInput(
          inputId = "fileName",
          label = "Enter a name for your file"
        ),
        textOutput(outputId = "userFileStatus")
      )
    )
    )
)



server <- function(input, output) {
  
  userDetails <- if(file.exists("user.csv"))
    read_csv("user.csv")
  
  output$userFileStatus <- renderText({
    fileCheck <- ifelse(is.null(userDetails),
                        "You have not specified a file",
                        "Your file exists")
  })
  
  
  rv <- reactiveValues(data = rnorm(100))
  
  observeEvent(input$norm, { rv$data <- rnorm(100) })
  observeEvent(input$unif, { rv$data <- runif(100) })
  
  output$hist <- renderPlot({
    hist(rv$data)
  })
  
  
  
###termination function, possibly in wrong place
  shinyServer(function(input, output, session){
    session$onSessionEnded(function() {
      stopApp()
    })
  })
  
}

shinyApp(ui = ui, server = server)