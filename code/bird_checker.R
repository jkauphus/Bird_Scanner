# Bird checker - script to check the classifiers to see if the model is accurately predicting species
## Will need to run this code following a code session with the bird_scanner.R script

# 1. libraries
library(tidyverse)
library(readxl)
library(glue)

# Load in results table from the Birdnet session that you want to investigate in------------------------------
table_name <- "birdNET_results_2023-08-20.xlsx"

results <- read_excel(glue("./results_tables/{table_name}", sheet = 1))

### What species or observation do you want to verify?
species <- "House Finch"

## subset the table
verify <- results %>% 
  filter(common_name == glue("{species}"))

# Check the audio segments of the BirdNet prediction results in wav audio format
# Read in the bird_verify function
source("./code/bird_verify.R")

# Verify detections in the checker folder-------------------------------------
bird_verify(verify)

### CHECK RESULTS IN THE "checker" folder#################################

# Check the audio segments of the BirdNet prediction results in spectrogram format
# Read in the bird_verify function
source("./code/bird_spec.R")

# verify detections in the spectrograms folder
bird_spec(verify)
### CHECK RESULTS IN THE "spectrograms" folder

##################
#Delete Results for both the checker and spectrograms folder before running bird_checker again
##################
# 
