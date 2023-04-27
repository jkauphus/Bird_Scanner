# Script is to grab the potential species list that BirdNET uses to narrow down its predictions
# The following code outputs the potential species list for the specific bird_scanner.R run
# Extract first week
#
#rec.path <- list.files(data, pattern = '.wav|.mp3', recursive = TRUE, ignore.case = TRUE)
#recIDs <- basename(rec.path[1])
#wk <- week(as.Date(unlist(lapply(strsplit(x = recIDs, split = '_'), '[[', 2)),format = '%Y%m%d'))
#wk = 20
# Pre-reqs for species.py
#current.wd <- glue("{getwd()}/BirdNET-Analyzer-main")
#setwd(current.wd)

# Run my version of the species2.py script located in the BirdNET-Analyzer-main folder
spec_list <- function(x){
  # Pull in the date information from the first file in the input folder
  rec.path <- list.files(data, pattern = '.wav|.mp3', recursive = TRUE, ignore.case = TRUE)
  recIDs <- basename(rec.path[1])
  wk <- week(as.Date(unlist(lapply(strsplit(x = recIDs, split = '_'), '[[', 2)),format = '%Y%m%d'))
  # Confidence pool, apparently for the species list if you set the confidence threshold too high it will remove
  # species it is not confidence predicting with but will still predict them in the outputs
  spec_conf <- 0.15
  # Re-set Working directory for BirdNET-Analyzer-main folder
  current.wd <- glue("{getwd()}/BirdNET-Analyzer-main")
  setwd(current.wd)
  py_run_string(paste0("args_i = '", data, "'"))
  py_run_string(paste0("args_o = '", output, "'"))
  py_run_string(paste0("args_lat = ", latitude))
  py_run_string(paste0("args_lon = ", longitude))
  py_run_string(paste0("args_week = ", wk))
  py_run_string(paste0("args_threshold = ", spec_conf))
  source_python("species2.py")
  
  # Re-set Working directory to repo main
    setwd("..")
  # pull in the species potential table
    species_list<-read.delim(glue("{output}/species_list.txt"), sep = "_", header = FALSE)
    names(species_list) <- c("scientific_name", "common_name")
    unlink(glue("{output}/species_list.txt"))
    return(species_list)
}


