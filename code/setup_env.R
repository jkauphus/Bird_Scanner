# Set-Up Bird Scanner

Sys.setenv(RETICULATE_PYTHON = "C:/Users/jkauphusman/Anaconda3/envs/testconda/python.exe")
library(reticulate)
library(tidyverse)
library(openxlsx)
library(glue)

# Set-up conda env
use_condaenv(condaenv = "testconda", required = TRUE)
sys <- import("sys", convert = TRUE)
# To run the scripts you need to create and activate a conda environment

# Info for when the conda environment does not upload properly
## in the anaconda terminal run the following
            #1. conda create -n pybirdanalyze python=3.7
            #2. conda activate pybirdanalyze
            #3. pip install --upgrade pip
            #4. pip install tensorflow
            #5. pip install librosa resampy
            #6. pip install numpy==1.20
            #7. pip install birdnetlib
            #8. pip install pandas
            #9. pip install xlsxwriter
            #10. pip install datetime
            #11. pip install ffmpeg