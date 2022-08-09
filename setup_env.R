# Set-Up Bird Scanner

Sys.setenv(RETICULATE_PYTHON = "C:/Users/JKauphusman/AppData/Local/r-miniconda/envs/pybirdanalyze/python.exe")
library(reticulate)

# Set-up conda env
use_condaenv(condaenv = "pybirdanalyze", required = TRUE)

birdnet_model <- "C:/Users/JKauphusman/OneDrive - Logan Simpson/Documents/BirdNET-Analyzer-main"