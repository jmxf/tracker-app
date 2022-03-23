#tracker-app
library(shiny)
ui <- fluidPage(
  fluidRow(
    tags$h1("This is an APP"),
    tags$a(href = "https://github.com/jmxf", "My GitHub Profile"),
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
}

shinyApp(ui = ui, server = server)



###video paused at 1:59:13

###shinyapps.io
###put images in www folder

###user commit test change