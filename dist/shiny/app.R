#tracker-app
library(shiny)
ui <- fluidPage(
#  theme = "filename.css",
  titlePanel(title = "Tracker App", windowTitle = "Tracker App"),
  
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  ),
  
  fluidRow(
    column(2, offset = 8, tags$a(href = "https://github.com/jmxf", "My GitHub Profile")),
    tags$br()
  ),
  fluidRow(
    column(2, actionButton(inputId = "norm", label = "Normal")),
    column(2, actionButton(inputId = "unif", label = "Uniform"))
  ),
  fluidRow(
    column(8, offset = 2, plotOutput("hist"))
  )
)

server <- function(input, output) {
  
  rv <- reactiveValues(data = rnorm(100))
  
  observeEvent(input$norm, { rv$data <- rnorm(100) })
  observeEvent(input$unif, { rv$data <- runif(100) })
  
  output$hist <- renderPlot({
    hist(rv$data)
  })
  
  shinyApp(ui = ui, server = server)
  
###termination function, possibly in wrong place
  shinyServer(function(input, output, session){
    session$onSessionEnded(function() {
      stopApp()
    })
  })
  
}

shinyApp(ui = ui, server = server)


###put images and additional css file in www folder