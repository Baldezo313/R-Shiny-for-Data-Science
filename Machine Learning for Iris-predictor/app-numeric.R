##############################

# BALDEZO313                # 

############################


# Import libraries
library(shiny)
library(data.table)
library(randomForest)

# Read in the RF model
model <- readRDS("model.rds")


#############################
#      User Interface       #
############################

ui <- pageWithSidebar(
  # Page header
  headerPanel('Iris Predictor'),
  
  # Input Values
  sidebarPanel(
    #HTML("<h3>Input parameters</h3>"),
    tags$label(h3('Input parameters')),
    numericInput("Sepal.Length", label = "Sepal Length", value = 5.1),
    numericInput("Sepal.Width", label = "Sepal Width", value = 3.6),
    numericInput("Petal.Length", label = "Petal Length", value = 1.4),
    numericInput("Petal.Width", label = "Petal Width", value = 0.2),
    actionButton("submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('Status/Output')),           # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata')                   # Prediction resuts table
  )
)


##############################
#     Server                 #
#############################

server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({
    df <- data.frame(
      "Sepal Length" = input$Sepal.Length,
      "Sepal Width" = input$Sepal.Width,
      "Petal Length" = input$Petal.Length,
      "Petal Width" = input$Petal.Width,
      stringsAsFactors = FALSE
    )
    
    Output <- data.frame(Prediction=predict(model, df), round(predict(model, df, type = "prob"), 3))
    return(Output)
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) {
      isolate("Calculation Complete.")
      
    } else {
      return("Server is ready for Calculation.")
    }
    
  })
  
  # Prediction results Table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) {
      isolate(datasetInput())
    }
  })
}


#######################################
#     Create the Shiny App            #
#######################################

shinyApp(ui = ui, server = server)


