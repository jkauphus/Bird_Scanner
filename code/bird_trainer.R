
# Run my version of the "train.py" script located in the BirdNET folder 
#to be able to create a custom classifier with birdnet for your species observations

train_birdnet_model <- function(
    training_path,         # Full subfolder Path
    output,                # Full output folder path ex: /output.tflite
    epochs = 100,          # Default value for epochs
    batch_size = 32,       # Default value for batch_size
    learning_rate = 0.01,  # Default value for learning_rate
    hidden_units = 0       # Default value for hidden_units
) {
  # Re-set Working directory for BirdNET-Analyzer-main folder
  current.wd <- glue("{getwd()}/BirdNET")
  setwd(current.wd)
  py_run_string(paste0("args_i = '", training_path, "'"))
  py_run_string(paste0("args_o = '", output, "'"))
  py_run_string(paste0("args_epochs = ", epochs))
  py_run_string(paste0("args_batch_size = ", batch_size))
  py_run_string(paste0("args_learning_rate = ", learning_rate))
  py_run_string(paste0("args_hidden_units = ", hidden_units))
  source_python("train2.py")
  
  # Re-set Working directory to repo main
  setwd("..")
}

# Test material
#training_path = "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/training_data_example"
#output = "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/" # output.tflite
#epochs = 100          # Default value for epochs
#batch_size = 32       # Default value for batch_size
#learning_rate = 0.01  # Default value for learning_rate
#hidden_units = 0 


#train_birdnet_model(training_path = "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/training_data_example",
#                    output = "C:/Users/jkauphusman/Desktop/Scripts/Bird_Scanner/output.tflite")

# training_path = Path to training data folder. Subfolder names are used as labels.
# output = Path to trained classifier model output.
# epochs = --epochs, Number of training epochs. Defaults to 100.
# batch_size = batch_size, Batch size. Defaults to 32.
# learning_rate = learning_rate, Learning rate. Defaults to 0.01.
# hidden_units = hidden_units, Number of hidden units. Defaults to 0. If set to >0, a two-layer classifier is used.