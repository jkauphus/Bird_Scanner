# Set-up Script (https://rdrr.io/github/nationalparkservice/NSNSDAcoustics/f/README.md#installing-nsnsdacoustics)
install.packages("remotes")
remotes::install_github("nationalparkservice/NSNSDAcoustics")

# conda env path: C:\Users\JKauphusman\AppData\Local\r-miniconda\envs\pybirdanalyze

Sys.setenv(RETICULATE_PYTHON = "C:/Users/JKauphusman/AppData/Local/r-miniconda/envs/pybirdanalyze/python.exe")
library(reticulate)

# Set-up conda env
use_condaenv(condaenv = "pybirdanalyze", required = TRUE)

# Below are the birdnet_analyzer functions and their examples: --------------------------------------------------------------------------

## Create an audio directory for this example
dir.create('example-audio-directory')

## Create a results directory for this example
dir.create('example-results-directory')

## Read in example wave files
data(exampleAudio1)
data(exampleAudio2)

# Write example waves to example audio directory
tuneR::writeWave(object = exampleAudio1,
                 filename = 'example-audio-directory/Rivendell_20210623_113602.wav')
tuneR::writeWave(object = exampleAudio2,
                 filename = 'example-audio-directory/Rivendell_20210623_114602.wav')

# Run all audio data in a directory through BirdNET -------------------------------------------------------------------------
X <- birdnet_analyzer(audio.directory = 'C:/Users/JKauphusman/Desktop/Scripts/Bird_Scanner/example-audio-directory',
                 results.directory = 'C:/Users/JKauphusman/Desktop/Scripts/Bird_Scanner/example-results-directory',
                 birdnet.directory = 'C:/Users/JKauphusman/OneDrive - Logan Simpson/Documents/BirdNET-Analyzer-main',
                 lat = 46.09924,
                 lon = -123.8765)

#unlink(x = 'example-audio-directory', recursive = TRUE)
#unlink(x = 'example-results-directory', recursive = TRUE)

# Function to Format the Data -----------------------------------------------------------------------------------------------

birdnet_format(results.directory = 'example-results-directory',
               timezone = 'GMT')

# Gather formatted BirdNET results ------------------------------------------------------------------------------------------
formatted.results <- birdnet_gather(
  results.directory = 'example-results-directory',
  formatted = TRUE)

# Gather unformatted (raw) BirdNET results
raw.results <- birdnet_gather(
  results.directory = 'example-results-directory',
  formatted = FALSE)

# Verify Results of a particular Species

### Create a random sample of three detections to verify
set.seed(4)
to.verify <- formatted.results[common_name == "Swainson's Thrush"][sample(.N, 3)]

# Create a verification library for this species
ver.lib <- c('y', 'n', 'unsure')

# Verify detections
birdnet_verify(data = to.verify,
               verification.library = ver.lib,
               audio.directory = 'example-audio-directory',
               results.directory = 'example-results-directory',
               overwrite = FALSE, 
               play = TRUE,
               frq.lim = c(0, 12),
               buffer = 1,
               box.col = 'blue',
               spec.col = monitoR::gray.3())
# Check that underlying files have been updated with user verifications
dat <- birdnet_gather(results.directory = 'example-results-directory',
                      formatted = TRUE)
dat[!is.na(verify)]
