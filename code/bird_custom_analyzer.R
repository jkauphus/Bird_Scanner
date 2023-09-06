# Wrapper Function

bird_custom_analyzer <- function(data,latitude,longitude, day, month, year, custom_model_path, custom_labels_path, conf){
  # Pull in the date information from the first file in the input folder
  # Import Information
  py_run_string(paste0("args_d = '", glue("{data}"), "'"))
  py_run_string(paste0("args_lat = ", latitude))
  py_run_string(paste0("args_lon = ", longitude))
  py_run_string(paste0("args_day = ", day))
  py_run_string(paste0("args_mon = ", month))
  py_run_string(paste0("args_yr = ", year))
  py_run_string(paste0("args_threshold = ", conf))
  py_run_string(paste0("args_custom_model = '", glue("{custom_model_path}"), "'"))
  py_run_string(paste0("args_custom_model_labels = '", glue("{custom_labels_path}"), "'"))
  source_python("./code/birdnetlib_custom_model.py")
  as.table(return())
}
