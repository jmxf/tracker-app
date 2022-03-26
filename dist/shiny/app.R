#tracker-app
library(shiny)
ui <- fluidPage(
  list(tags$head(HTML('<link rel="icon", href="JAM-logos-colour-adj.jpg",
                      type="image/jpg" />'))),
  div(style = "padding: 1px 0px; width: '100%'",
      titlePanel(
        title = "", windowTitle = "Window Title"
      )),
  navbarPage(
    title = tags$div(img(src = "JAM-logos-colour-adj.jpg", height = 150), title = "Tracker App"),
    
    
    tabPanel(title = "Data Input"),
    tabPanel(title = "Analysis"),
    tabPanel(title = "Settings")
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