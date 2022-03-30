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
  
  windowTitle = "Window Title",
  title = tags$div(img(src = "JAM-logos-colour-adj-crop.jpg", height = 75),
                   title = "Tracker App"),
  position = "static-top",

###Data Input tab  
  tabPanel(title = "Data Input",
           fluidRow(
             column(
               width = 12,
               helpText(
                 tags$p("Input your data by selecting a Category on the drowpdown and 
                  filling in the text field.")
               )
             )
           ),
           fluidRow(
             column(
               width = 4,
               selectInput(
                 inputId = "trackedCategory",
                 label = "Category",
                 choices = categories,
                 multiple = FALSE
               )
             ),
             column(
               width = 4,
               dateInput(
                 inputId = "trackedDate",
                 label = "Date",
                 format = "dd.mm.yyyy",
                 weekstart = 1
               )
             )
           ),
           fluidRow(
             column(
               width = 4,
               #create something more suitable to eventually be able to submit
               #times in HH:MM format
               numericInput(
                 inputId = "trackedTime",
                 label = "Amount of Time in Minutes",
                 value = 0
               )
             )
           ),
           fluidRow(
             column(
               width = 12,
               textAreaInput(
                 inputId = "trackedComment",
                 label = "Notes",
                 width = "100%",
                 placeholder = "Enter details about the time tracked..."
               )
             )
           ),
           fluidRow(
             column(
               width = 4,
               actionButton(
                 inputId = "track",
                 label = "Track"
               )
             )
           )
           
  ),

###Analysis tab  
  tabPanel(title = "Analysis", value = "analysis"),

###Settings tab
  tabPanel(
    title = "Settings",
    value = "settings",
    sidebarLayout(
      sidebarPanel(
        style = "height: 100%",
        tags$p("Specify your settings for the App")
      ),
      mainPanel(
        fluidRow(
          column(width = 4,
            textInput(
              inputId = "fileLocation",
              label = "Select a location to save your data"
            )
          ),
          column(width = 4,
            textInput(
              inputId = "fileName",
              label = "Enter a name for your file"
            )
          ),
          column(width = 4,
            wellPanel(
              textOutput(outputId = "userFileStatus"),
              style = "background: #4D6A6D; color: #FFFFFF; font-weight: bold"
            )
          )
        ),
        fluidRow(
          column(
            width = 4,
            textInput(
              inputId = "addCategory",
              label = "Add new Category"
            )
          ),
          column(
            width = 8,
            wellPanel(
              tags$h6("Existing Categories"),
              textOutput("settingsTable")
            )
          )
        ),
        fluidRow(
          column(
            width = 4,
            actionButton(
              inputId = "updateSettings",
              label = "Update Settings"
            )
          )
        )
        



      )
    )
    )
)



server <- function(input, output) {
  
  userDetails <- if(file.exists("user.csv"))
    read_csv("user.csv")
  
###Data Input tab
  
  categories <- str_split(
    string = userDetails$categories,
    pattern = ";"
  )
  
###Analysis tab
  
###Settings tab  
  
  output$userFileStatus <- renderText({
    ifelse(is.null(userDetails),
           "You have not specified a file",
           "Your file exists")
  })
  
  
  observeEvent(input$updateSettings, {
    userSpecifications <- data.frame(
      "location" = input$fileLocation,
      "fileName" = input$fileName,
      "categories" = input$addCategory
    )
    output$settingsTable <- renderText(userSpecifications$categories)
    print(as.numeric(input$updateSettings))
    print(userSpecifications)
    write_csv(x = userSpecifications, file = "user.csv")
  })
  
 
  
  
  
###termination function, possibly in wrong place
  shinyServer(function(input, output, session){
    session$onSessionEnded(function() {
      stopApp()
    })
  })
  
}

shinyApp(ui = ui, server = server)