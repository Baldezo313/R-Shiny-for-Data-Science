########################

# Baldezo             #

#######################

# Importing libraries
library(RCurl)    # For downloading the iris CSV file
library(randomForest)
library(caret)

# Importing the Iris data set

iris <- read.csv(text = getURL("https://raw.githubusercontent.com/Baldezo313/R-Shiny-for-Data-Science/refs/heads/main/iris.csv"))

# Performs stratified random split of the dataset
TrainingIndex <- createDataPartition(iris$Species, p=0.8, list = FALSE)
TrainingSet <- iris[TrainingIndex, ]  # Training Set
TestingSet <- iris[-TrainingIndex, ]  # Test Set

write.csv(TrainingSet, "training.csv")
write.csv(TestingSet, "testing.csv")

TrainSet <- read.csv("training.csv", header = TRUE)
TrainSet <- TrainSet[, -1]
TrainSet$Species <- as.factor(TrainSet$Species)


# Building Random Forest model
model <- randomForest(Species ~ ., data = TrainSet, ntree = 500, mtry = 4, importance = TRUE)

# Save model to RDS file
saveRDS(model, "model.rds")