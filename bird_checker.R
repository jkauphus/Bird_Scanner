# Bird checker - script to check the classifiers to see its real time accuracy

# 1. libraries
source("./setup_env.R")
library(NSNSDAcoustics)
library(tidyverse)
library(glue)
library(readxl)
library(writexl)

# linke original wavefile folder
audio-directory <-""
output <- ""

# Load in table
table_filepath <- ""

results <- read_excel(glue("{table_filepath}"), sheet = 2)

### What species or observation do you want to verify?
set.seed(4)
species <- "Mourning Dove"

to.verify <- formatted.results %>% 
  filter(common_name == glue("{species}"))

# Create a verification library for this species
ver.lib <- c('y', 'n', 'unsure')

# Verify detections
birdnet_verify(data = to.verify,
               verification.library = ver.lib,
               audio.directory = 'audio-directory',
               results.directory = 'output',
               overwrite = FALSE, 
               play = TRUE,
               frq.lim = c(0, 12),
               buffer = 1,
               box.col = 'blue',
               spec.col = monitoR::gray.3())

# Check that underlying files have been updated with user verifications
dat <- birdnet_gather(results.directory = 'output',
                      formatted = TRUE)
dat[!is.na(verify)]