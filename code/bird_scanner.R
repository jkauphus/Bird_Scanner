# This script is to build out the Birdnet-analyzer functions in R from the data collected from deployed ARUs

# 1. Load Libraries and dependencies---------------------------------------------
source("./code/setup_env.R")
library(NSNSDAcoustics)
library(tidyverse)
library(openxlsx)
library(glue)

# 2. Load in the .wav files collected from the ARU at the folder level -----------------------------------------------

## Note that the .wav files need to abide to the format = SITEID_YYYYMMDD_HHMMSS 
## and some ARUs only writes it out as YYYYMMDD_HHMMSS so run the source("file_rename.R") script
# Designate input folder
filepath <- "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner"
data <- glue("{filepath}/data")

# Name your Project Site
SiteName <- "Backyard"
## Comment out code chunk below if you need to change the filenames for the file format
#source("file_renamer.R")

## Designate output folder ------------------------------------------------------------------------------------------

output <- glue("{filepath}/", "results-directory")

#3. Where did you deploy the device? --------------------------------------------------------------------------------

# Web Mercator Please!!
## Find the Coordinates 'https://WWW.google.com/maps/', will make this more responsive in the future

latitude <- 33.264587
longitude <- -111.869099

## What confidence threshold do you want the model to predict from
## Note Based on the confidence threshold will reduce the amount of birds the model will predict 
conf <- 0.75

#4. Run the wav files through the Birdnet-Analyzer CNN -------------------------------------------------------------

birdnet_analyzer(audio.directory = data,
                 results.directory = output,
                 birdnet.directory = birdnet_model,
                 use.week = TRUE,
                 lat = latitude,
                 lon = longitude,
                 min.conf = conf)

#5. Output the potential species that occur within the project area that the model will predict from----------------
source("./code/species_list.R")
spec_list <- spec_list()

# 4. Format the raw results into a data table --------------------------------------------------------------------- 
birdnet_format(results.directory = output,
               timezone = 'MST') # Double Check due to timezone changes

results_table <- birdnet_gather(results.directory = output,
                  formatted = TRUE)

#5. Save the results to an excel table for easy use --------------------------------------------------------------
## setting up excel workbook
workbook <- createWorkbook()
results <- addWorksheet(workbook, "BirdNET Results")
Spec <- addWorksheet(workbook, "Potential Species in Project")
## adding the datatables to two sheets
writeData(workbook, Spec, spec_list)
writeData(workbook, results, results_table)

# Change filepath if you want to save the outputs in a different location
saveWorkbook(workbook, glue("./results_table/{SiteName}_results_table.xlsx"), overwrite = TRUE)

