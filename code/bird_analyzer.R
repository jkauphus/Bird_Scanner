# Script is to use the birdnetlib library to access BirdNet using https://github.com/joeweiss/birdnetlib
# The following code is to create a wrapper function for R

# Wrapper Function

bird_analyzer <- function(data,latitude,longitude, conf){
  # Pull in the date information from the first file in the input folder
  # Import Information
  py_run_string(paste0("args_d = '", glue("{data}"), "'"))
  py_run_string(paste0("args_lat = ", latitude))
  py_run_string(paste0("args_lon = ", longitude))
  py_run_string(paste0("args_threshold = ", conf))
  source_python("./code/birdnetlib_analyzer.py")
  as.table(return())
}
