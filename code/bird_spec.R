# Script to create a function to improve the quality of the spectrogram outputs

library(ggplot2)
library(umap)
library(seewave)
library(tuneR)
library(phonTools)
library(signal)
library(warbleR)

# grab the first name
#audio <- tuneR::readWave(glue("{verify$filepath[1]}"))
#start_time <- sum(verify$start[1]-1)
#end_time <- sum(verify$end[1]+1)
#trim <- cutw(audio, from = start_time, to = end_time, output = 'Wave')
#png(filename = "./spectrograms/output.png")
#par(mar = c(4.1, 4.4, 4.1, 1.9), xaxs="i", yaxs="i")
#spec <- seewave::spectro(trim, fftw = TRUE, grid = TRUE, osc = TRUE, 
#                         flim=c(0,8), main = paste0("\n", "\n", verify$common_name[1] , ' [Conf. = ',round(verify$confidence[1], 2), ']')) #listen = TRUE)
#dev.off()
## 
## ggspectro
#seewave::ggspectro(trim, fftw = TRUE, grid = TRUE,flim = c(0,8), f = 24000, tlab = "Time (s)",
#          flab = "Frequency (kHz)", alab = "Amplitude\n(dB)\n",)

# Now Converting the code into the function for bird_checker.R as the new bird_spec fucntion

spectro <- function(x){
  audio <- readWave(glue("{x$full_path}"))
  start_time <- max(x$start_time - 1, 0)
  end_time <- max(x$end_time + 1, 0)
  
  #Trim wav file to call when the call was predicted at
  seg <- cutw(audio, from = start_time, to = end_time, output = 'Wave')
  
  # settup output for spectrogram with ocsillogram to be saved into the spectrogram folder
  png(filename = glue("./spectrograms/{x$uniqueID}_{x$scientific_name}_{x$filename}.png"))
  par(mar = c(4.1, 4.4, 4.1, 1.9), xaxs="i", yaxs="i")
  
  # plot spectrogram with 
  spec <- seewave::spectro(seg, fftw = TRUE, grid = TRUE, osc = TRUE, 
                           flim=c(0,8), main = paste0("\n", "\n", x$common_name, ' [Conf. = ',x$confidence, ']')) #listen = TRUE)
  dev.off()
}

bird_spec <-function(df){
  uniqueID <- seq(1, nrow(df))
  df <- cbind(uniqueID, df)
  for (i in 1:nrow(df)){
    spectro(df[i,])
  }
}
  

