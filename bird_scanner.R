# This script is to build out the Birdnet-analyzer functions in R from the data collected from the Audiomoth

# 1. Load Libraries and dependencies---------------------------------------------
source("./setup_env.R")
library(NSNSDAcoustics)
library(tidyverse)
library(openxlsx)
library(glue)

# 2. Load in the .wav files collected from the audiomoth at the folder level -----------------------------------------------

## Note that the .wav files need to abide to the format = SITEID_YYYYMMDD_HHMMSS 
## and Audiomoth only writes it out as YYYYMMDD_HHMMSS so run the following script

filepath <- "//lsdnassrv/ndrive/projects/2022/225532C215139 NTUA Nazlini Biological Survey/Biology/Site Visit/Audio"
SiteName <- "Nazlini"
source("file_renamer.R")

## Designate output folder

output <- glue("{filepath}/", "results-directory", sep = "/")

#3. Where did you deploy the device? --------------------------------------------------------------------------------

# Web Mercator Please!!
## Find the Coordinates 'https://www.google.com/maps/', will make this more responsive in the future

latitude <- 35.902625
longitude <- -109.444607

#3. Run the wav files through the Birdnet-Analyzer CNN -------------------------------------------------------------
birdnet_analyzer(audio.directory = filepath,
                      results.directory = output,
                      birdnet.directory = birdnet_model,
                      lat = latitude,
                      lon = longitude,
                      min.conf = 0.3)

# 4. Format the raw results into a data table --------------------------------------------------------------------- 
birdnet_format(results.directory = output,
               timezone = 'MST') # Double Check due to timezone changes

results_table <- birdnet_gather(results.directory = output,
                  formatted = TRUE)

#5. Save the results to an excel table for easy use --------------------------------------------------------------
write.xlsx(results_table, glue("{filepath}/results_table.xlsx"))
