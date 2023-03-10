# Bird checker - script to check the classifiers to see its real time accuracy

# 1. libraries
source("./code/setup_env.R")
library(NSNSDAcoustics)
library(tidyverse)
library(glue)
library(readxl)
library(writexl)

# link original wavefile folder
filepath <- "N:/projects/2022/225188C215378 NTUA 14 Homesites Technical Studies (1.BIO)/Biology/Site Visit/Roderick Begay/Audio Analysis"
audiodirectory <-glue("{filepath}/audio")
output <- glue("{filepath}/results-directory")

# Load in table
table_filepath <- glue("{filepath}/results_table.xlsx")
results <- read_excel(glue("{table_filepath}"), sheet = 1)

### What species or observation do you want to verify?
set.seed(4)
species <- "Ladder-backed Woodpecker"

to.verify <- results %>% 
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
# In the Main Project Directory you will find the parsed out audio-files to review.

### For some reason, its a little buggy and won't re-write the directory, will need to fix this issue later 
dat <- birdnet_gather(results.directory = output,
                      formatted = TRUE)
dat[!is.na(verify)]
