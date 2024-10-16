# Load R packages
library(shiny)
library(shinythemes)


# Define UI
ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage("My first app",
                           tabPanel("Navbar 1",
                                    sidebarPanel(tags$h3("Input:"),
                                                 textInput("text1", "Given Name:", ""),
                                                 textInput("text2", "Surname:", ""),
                                                 ),
                                    mainPanel(h1("Header 1"),
                                              h4("Output 1"),
                                              verbatimTextOutput("txtout"),
                                              ),
                                    ),
                           
                            tabPanel("Navbar 2", "This panel is intentionally left blank"),
                            tabPanel("Navbar 3", "This panel is intentionally left blank")
                )
      )

# Define server function
server <- function(input, output) {
  output$txtout <- renderText({
    paste(input$text1, input$txt2, sep = " ")
  })
}


# Create Shiny object
shinyApp(ui = ui, server = server)