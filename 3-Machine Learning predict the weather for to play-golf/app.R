# Import libraries
library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)

# Read data

weather <- read.csv(text = getURL("https://raw.githubusercontent.com/Baldezo313/R-Shiny-for-Data-Science/refs/heads/main/weather-weka.csv"))

weather$play <- as.factor(weather$play)

# Build model
model <- randomForest(play ~ ., data = weather, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
# SaveRDS(model, "model.rds")

# Read in the RF model
# model <- readRDS("model.rds")

###############################
# User Interface              #
###############################

ui <- fluidPage(theme = shinytheme("united"),
                
                # Page Header
                headerPanel('Play Golf?'),
                
                # Input Values
                sidebarPanel(
                  HTML("<h3>Input parameters</h3>"),
                  
                  selectInput("outlook", label = "Outlook:",
                              choices = list("Sunny" = "sunny", "Overcast" = "overcast", "Rainy" = "rainy"), selected = "Rainy"),
                  sliderInput("temperature", "Temperature:", min = 64, max = 86, value = 70),
                  sliderInput("humidity", "Humidity:", min = 65, max = 96, value = 90),
                  checkboxInput("windy", label = "Windy", value = TRUE), # Use checkbox for boolean input,
                  actionButton("submitbutton", "Submit", class = "btn btn-primary")),
               
                mainPanel(
                  tags$label(h3('Status/Output')),     # Status/output Text Box
                  verbatimTextOutput('contents'),
                  tableOutput('tabledata')     # Prediction result table
                  
                )
        )


####################################

# Server                          #

##################################

server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({
    
    # outlook, temperature, humidity, windy,play
    # df <- data.frame(
    #   Name = c("outlook", "temperature", "humidity", "windy"),
    #   Value = as.character(c(input$outlook,
    #                          input$temperature,
    #                          input$humidity,
    #                          input$windy)),
    #   stringsAsFactors = FALSE
    # )
    # 
    # play <- "play"
    # df <- rbind(df, play)
    # input <- transpose(df)
    # write.table(input, "input.csv", sep = ",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    # test <- read.csv(paste("input", ".csv", sep = ""), header = TRUE)
    # 
    # test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
    # 
    
    df <- data.frame(
      outlook = input$outlook,  # Utiliser les mêmes niveaux que dans weather
      temperature = as.numeric(input$temperature),  # Convertir en numérique si nécessaire
      humidity = as.numeric(input$humidity),        # Convertir en numérique si nécessaire
      windy = as.logical(input$windy),              # Convertir en logique (TRUE/FALSE)
      stringsAsFactors = FALSE
    )
    
    # str(weather)  # Voir la structure du jeu de données d'entraînement pour vérifier les types
    # str(df) 
    
    Output <- data.frame(Prediction=predict(model, df), round(predict(model, df, type="prob"), 3))
    return(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) {
      isolate("Calculation complete.")
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) {
      isolate(datasetInput())
    }
  })
  
}


#####################################

# Create the shiny App              # 

####################################

shinyApp(ui = ui, server = server)












