# This script is to Demo the Birdnet-analyzer functions in R from the bird feeder calls from the Audiomoth at my house

# 1. Load Libraries and dependencies---------------------------------------------
source("./setup_env.R")
library(NSNSDAcoustics)
library(tidyverse)
library(openxlsx)
library(glue)

# PLAY DEMO CALL FOR GROUP: "C:\Users\JKauphusman\OneDrive - Logan Simpson\Documents\audio_moth\BirdFeederp3\20220815_082200.WAV"

# 2. Load in the .wav files collected from the audiomoth at the folder level -----------------------------------------------

## Note that the .wav files need to abide to the format = SITEID_YYYYMMDD_HHMMSS 
## and Audiomoth only writes it out as YYYYMMDD_HHMMSS so run the following script

filepath <- "C:/Users/jkauphusman/Desktop/test"

## Designate output folder

output <- glue("{filepath}/", "results-directory", sep = "/")

#3. Where did you deploy the device? --------------------------------------------------------------------------------

# Web Mercator Please!!
## Find the Coordinates 'https://www.google.com/maps/', will make this more responsive in the future

latitude <- 33.264587
longitude <- -111.869099

#3. Run the wav files through the Birdnet-Analyzer CNN -------------------------------------------------------------

birdnet_analyzer(audio.directory = filepath,
                 results.directory = output,
                 birdnet.directory = birdnet_model,
                 use.week = TRUE,
                 lat = latitude,
                 lon = longitude,
                 min.conf = 0.5)

# 4. Format the raw results into a data table --------------------------------------------------------------------- 
birdnet_format(results.directory = output,
               timezone = 'MST') # Double Check due to timezone changes

results_table <- birdnet_gather(results.directory = output,
                                formatted = TRUE)

#5. Save the results to an excel table for easy use --------------------------------------------------------------
write.xlsx(results_table, glue("{filepath}/results_table.xlsx"))

#6. Demo the bird checker functions on the house finch

### What species or observation do you want to verify? How about House Finch
set.seed(4)
species <- "House Finch"

to.verify <- results_table %>% 
  filter(common_name == glue("{species}"))

# Create a verification library for this species
ver.lib <- c('y', 'n', 'unsure')

# Verify detections
birdnet_verify(data = to.verify,
               verification.library = ver.lib,
               audio.directory = filepath,
               results.directory = output,
               overwrite = TRUE, 
               play = TRUE,
               frq.lim = c(0, 12),
               buffer = 1,
               box.col = 'blue',
               spec.col = monitoR::gray.3())

# Check that underlying files have been updated with user verification
######### IN THE RPROJECT FOR BIRD SCANNER Directory you will find the parsed out audio-files to review.#######
# C:\Users\JKauphusman\Desktop\Scripts\Bird_Scanner
### For some reason, its a little buggy and won't re-write the directory, will need to fix this issue later 



