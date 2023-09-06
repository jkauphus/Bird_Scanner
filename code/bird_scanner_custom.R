# This script is to run the bird_scanner_custom R wrapper function from the `birdnetlib_custom_model.py` script directly from the latest version of birdNET
# Here I will lay out the code to create a custom model based on personal avian call data and then run that new custom_model on a file of audio

#1. Review the train_data_example folder and create a folder that has background data and species data
source("./code/bird_trainer.R")
## Run the function to create a custom model
train_birdnet_model(training_path = "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/training_data_example",
                    output = "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/output.tflite")

#2. Now run the audio with the custom model

#Load in the .wav files collected from the ARU to the data folder -----------------------------------------------

data <- glue("./data")

#3. Where did you deploy the device? --------------------------------------------------------------------------------

# Web Mercator Please!!
## Find the Coordinates 'https://WWW.google.com/maps/', will make this more responsive in the future

latitude <- 33.264587
longitude <- -111.869099

# Date Information (Should have a date for the average in the directory for the month)

day <- 13
month <- 12
year <- 2022

# Now need to import the entire filepath for the custom_model and custom_model_labels

custom_model_path <- "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/custom_model/output.tflite"
custom_labels_path <- "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/custom_model/output_Labels.txt"

## What confidence threshold do you want the model to predict from
## Note Based on the confidence threshold will reduce the amount of birds the model will predict 
conf <- 0.75

#4a. Run the wav files through the Birdnet-Analyzer CNN -------------------------------------------------------------

source("./code/bird_custom_analyzer.R")
bird_custom_analyzer(data, latitude,longitude,day, month, year,
                     custom_model_path, custom_labels_path, conf)
#### CHECK THE RESULTS_TABLE FOLDER ####