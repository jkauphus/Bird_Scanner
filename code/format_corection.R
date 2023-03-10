# 1. libraries
library(glue)
library(tidyverse)

files <- list.files(glue("{output}/"), recursive = TRUE, full.names = FALSE)

#4. Start converting the files to their new names

names <- data.frame(files)

## Now lets paste it all together into one column
new_names <- newfilename <- sub(".csv", ".txt", names$files)
new_names <- paste(glue("{output}/"), new_names)

original_filenames <- list.files(glue("{output}/"), recursive = TRUE, full.names = TRUE)

file.rename(original_filenames, new_names)
