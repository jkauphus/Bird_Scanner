# This script is to build out the Birdnet-analyzer functions in R from the data collected from the Audiomoth

# 1. Load Libraries and dependancies---------------------------------------------
source("./setup_env.R")
library(NSNSDAcoustics)
library(tidyverse)
library(glue)

# 2. Load in the .wav files collected from the audiomoth at the folder level

## Note that the .wav files need to abide to the format = SITEID_YYYYMMDD_HHMMSS 
## and Audiomoth only writes it out as YYYYMMDD_HHMMSS so run the following script

## TO DO!!

input_folder <- "C:/Users/JKauphusman/Desktop/audio_tester"

## Designate output folder

output_folder <- "C:/Users/JKauphusman/Desktop/Scripts/Bird_Scanner/results-directory"

#3. Where did you deploy the device?

# Web Mercator Please!!
latitude <- 33.2666
longitude <- -111.8690

#3. Run the wav files through the Birdnet-Analyzer CNN
birdnet_analyzer(audio.directory = input_folder,
                      results.directory = output_folder,
                      birdnet.directory = birdnet_model,
                      lat = latitude,
                      lon = longitude,
                      min.conf = 0.3)

# 4. Format the raw results into a data table 
birdnet_format(results.directory = output_folder,
               timezone = 'MST') # Double Check due to timezone changes

results_table <- birdnet_gather(results.directory = output_folder,
                  formatted = TRUE)
