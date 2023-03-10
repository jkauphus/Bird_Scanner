#load package
library(tuneR)
library(seewave)
library(ggplot2)

# Write it out once, than create the function or loop
#audio <- readWave(glue("{verify$filepath[1]}"))
#start_time <- sum(verify$start[1]-5)
#end_time <- sum(verify$end[1]+5)
# pre-reqs
#frq.lim = c(0, 12)
#spec.col =  monitoR::gray.3()
#box.col = 'blue'
#check.sp <- monitoR:::spectro(wave = audio) # monitoR:::
#which.frq.bins <- which(check.sp$freq >= frq.lim[1] &
#                          check.sp$freq <= frq.lim[2])
#Spectrogram
#reclen <- length(audio@left)/audio@samp.rate
#fft.data <- monitoR:::spectro(wave = audio)
#trec <- fft.data$time
#frec <- fft.data$freq
#arec <- fft.data$amp
#frec <- frec[which.frq.bins]
#arec <- arec[which.frq.bins, ]
# For plotting, save object to help label hh:mm:ss on x-axis
#trec.times <- as.ITime(trec)
#time.lab <- 'Time in recording (hh:mm:ss)'
#t.step <- trec[2] - trec[1]
#true.times.in.rec <- seq(from = start_time, to = end_time, by = t.step)[1-length(trec)]
# Set up the graphics device
#saver<-glue("./spectrograms/{verify$scientific_name[1]}_{verify$recordingID[1]}.png")
#png(saver)
# Plot
#par(mfrow = c(1,1), mar = c(3,3,2,1), mgp = c(2,1,0))
#image(x = trec, y = frec, z = t(arec), col = spec.col,
#xlab = time.lab, ylab = "Frequency (kHz)", xaxt = "n",
#bty = 'n', axes = FALSE,
#main = paste0(verify$common_name[1] , ' [Conf. = ',
#              round(verify$confidence[1], 2), ']'))

# Add a buffer box around the 3 second clip
#xleft <- trec[which.min(abs(true.times.in.rec - verify$start[1]))]
#xright <- trec[which.min(abs(true.times.in.rec - verify$end[1]))]
##ylwr <- min(frec)
#yupr <- max(frec)
#polygon(x = c(xleft, xleft, xright, xright),
#        y = c(ylwr, yupr, yupr, ylwr), border = box.col)
#axis(2, at = pretty(frec), labels = pretty(frec))
#axis(1, at = pretty(trec),
#     labels = as.ITime(pretty(true.times.in.rec))[1:length(pretty(trec))])
#dev.off()

spectro <- function(x){
  audio <- readWave(glue("{x$filepath}"))
  start_time <- sum(x$start -5)
  end_time <- sum(x$end +5)
  # pre-reqs
  frq.lim = c(0, 12)
  spec.col =  monitoR::gray.3()
  box.col = 'blue'
  check.sp <- monitoR:::spectro(wave = audio) # monitoR:::
  which.frq.bins <- which(check.sp$freq >= frq.lim[1] &
                            check.sp$freq <= frq.lim[2])
  
  #Spectrogram Info
  reclen <- length(audio@left)/audio@samp.rate
  fft.data <- monitoR:::spectro(wave = audio)
  trec <- fft.data$time
  frec <- fft.data$freq
  arec <- fft.data$amp
  frec <- frec[which.frq.bins]
  arec <- arec[which.frq.bins, ]
  # For plotting, save object to help label hh:mm:ss on x-axis
  trec.times <- as.ITime(trec)
  time.lab <- 'Time in recording (hh:mm:ss)'
  t.step <- trec[2] - trec[1]
  true.times.in.rec <- seq(from = start_time, to = end_time, by = t.step)[1-length(trec)]
  # Set up the graphics device
  saver<-glue("./spectrograms/{x$uniqueID}_{x$scientific_name}_{x$recordingID}.png")
  png(saver)
  # Plot
  par(mfrow = c(1,1), mar = c(3,3,2,1), mgp = c(2,1,0))
  image(x = trec, y = frec, z = t(arec), col = spec.col,
        xlab = time.lab, ylab = "Frequency (kHz)", xaxt = "n",
        bty = 'n', axes = FALSE,
        main = paste0(x$common_name , ' [Conf. = ',
                      round(x$confidence, 2), ']'))
  
  # Add a buffer box around the 3 second clip
  xleft <- trec[which.min(abs(true.times.in.rec - x$start))]
  xright <- trec[which.min(abs(true.times.in.rec - x$end))]
  ylwr <- min(frec)
  yupr <- max(frec)
  polygon(x = c(xleft, xleft, xright, xright),
          y = c(ylwr, yupr, yupr, ylwr), border = box.col)
  axis(2, at = pretty(frec), labels = pretty(frec))
  axis(1, at = pretty(trec),
       labels = as.ITime(pretty(true.times.in.rec))[1:length(pretty(trec))])
  dev.off()
  }

bird_spec <-function(df){
  uniqueID <- seq(1, nrow(df))
  df <- cbind(uniqueID, df)
  for (i in 1:nrow(df)){
    spectro(df[i,])
  }
}
