# 1. libraries
library(glue)
library(tidyverse)

#2. Import Table of PhotoID Nums

#filepath <- "N:/projects/2022/225394C215139 NTUA Lechee to Antelope Biological Survey (1.BIO)/Biology/Site Visit/Audio Files/20220824"
#SiteName <- "LecheetoAntelop"

#3. Pull in the filenames for the wav files

files <- list.files(glue("{filepath}/"), recursive = TRUE, full.names = FALSE)

#4. Start converting the files to their new names

file_names <- data.frame(files)

## Now lets paste it all together into one column
new_files <- paste(filepath,"/", SiteName,"_", file_names$files, sep = "")

original_filenames <- list.files(glue("{filepath}/"), recursive = TRUE, full.names = TRUE)

file.rename(original_filenames, new_files)
