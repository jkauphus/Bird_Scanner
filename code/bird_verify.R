library(tuneR)
library(glue)

# Write it out once, than create the function or loop
#audio <- readWave(glue("{verify$filepath[1]}"))
#start_time <- sum(verify$start[1]-5)
#end_time <- sum(verify$end[1]+5)
#start_sample <- as.integer(start_time * audio@samp.rate)
#end_sample <- as.integer(end_time * audio@samp.rate)

# Extract the segment
#segment <- audio[start_sample:end_sample]

# Save the segment to a new WAV file
#writeWave(segment, glue("./checker/{to.verify$scientific_name[1]}_{to.verify$recordingID[1]}"))
#play(segment)

bird_checker <- function(x){
  audio <- readWave(glue("{x$full_path}"))
  start_time <- max(x$start_time - 5, 0)
  end_time <- max(x$end_time + 5, 0)
  start_sample <- as.integer(start_time * audio@samp.rate)
  end_sample <- as.integer(end_time * audio@samp.rate)
  segment <- audio[start_sample:end_sample]
  writeWave(segment, glue("./checker/{x$uniqueID}_{x$scientific_name}_{x$filename}"))
}

bird_verify <-function(df){
  uniqueID <- seq(1, nrow(df))
  df <- cbind(uniqueID, df)
  for (i in 1:nrow(df)){
  bird_checker(df[i,])
  }
}

#bird_verify(to.verify)
