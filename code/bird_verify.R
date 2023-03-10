library(tuneR)

# Write it out once, than create the function or loop
#audio <- readWave(glue("{to.verify$filepath[1]}"))
#start_time <- sum(to.verify$start[1]-5)
#end_time <- sum(to.verify$end[1]+5)

# Extract the segment
#segment <- window(audio, from = start_time, to = end_time)

# Save the segment to a new WAV file
##writeWave(segment, glue("./checker/{to.verify$scientific_name[1]}_{to.verify$recordingID[1]}"))
#play(segment)

bird_checker <- function(x){
  audio <- readWave(glue("{x$filepath}"))
  start_time <- sum(x$start -5)
  end_time <- sum(x$end +5)
  segment <- window(audio, from = start_time, to = end_time)
  writeWave(segment, glue("./checker/{x$uniqueID}_{x$scientific_name}_{x$recordingID}"))
}

bird_verify <-function(df){
  uniqueID <- seq(1, nrow(df))
  df <- cbind(uniqueID, df)
  for (i in 1:nrow(df)){
  bird_checker(df[i,])
  }
}

#bird_verify(to.verify)
