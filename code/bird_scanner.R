# This script is to run the bird_scanner R wrapper function from the `birdnetlib_analyzer.py` script directly from the latest version of birdNET

# 1. Load Libraries and dependencies---------------------------------------------
source("./code/setup_env.R")
library(tidyverse)
library(openxlsx)
library(glue)

# 2. Load in the .wav files collected from the ARU to the data folder -----------------------------------------------

## Note that the .wav files need to contain the following data information "YYYYMMDD_HHMMSS" 

data <- glue("./data")

#3. Where did you deploy the device? --------------------------------------------------------------------------------

# Web Mercator Please!!
## Find the Coordinates 'https://WWW.google.com/maps/', will make this more responsive in the future

latitude <- 33.264587
longitude <- -111.869099

## What confidence threshold do you want the model to predict from
## Note Based on the confidence threshold will reduce the amount of birds the model will predict 
conf <- 0.75

#4. Run the wav files through the Birdnet-Analyzer CNN -------------------------------------------------------------

source("./code/bird_analyzer.R")
bird_analyzer(data=data, latitude=latitude, longitude=longitude, conf=conf)

#### CHECK THE RESULTS_TABLE FOLDER ####

