# This script is to run the bird_scanner R wrapper function from the `birdnetlib_analyzer.py` script directly from the latest version of birdNET
source("./code/setup_env.R")

# 1. Load in the .wav files collected from the ARU to the data folder -----------------------------------------------

data <- glue("C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/data")

#3. Where did you deploy the device? --------------------------------------------------------------------------------

# Web Mercator Please!!
## Find the Coordinates 'https://WWW.google.com/maps/', will make this more responsive in the future

latitude <- 33.264587
longitude <- -111.869099

# Date Information (Should have a date for the average in the directory for the month)

day <- 13
month <- 12
year <- 2022

## What confidence threshold do you want the model to predict from
## Note Based on the confidence threshold will reduce the amount of birds the model will predict 
conf <- 0.75

#4a. Run the wav files through the Birdnet-Analyzer CNN -------------------------------------------------------------

source("./code/bird_analyzer.R")
bird_analyzer(data,latitude,longitude,day, month, year, conf)

#### CHECK THE RESULTS_TABLE FOLDER ####