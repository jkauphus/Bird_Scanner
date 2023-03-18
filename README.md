# Bird_Scanner

![image](https://user-images.githubusercontent.com/54585357/192024913-dfe51948-b297-4043-bfef-e110efe34690.png)

These scripts and workflow (https://jkauphus.github.io/Bird_Scanner/) are to develop an R ecosystem and eventual application to run the Bird-Net Algorithm in R.

These scripts are modified on the NSNSDAcoutics R package that leverages the Bird-Net tensorflow model to extract avian calls through wav files in a very streamline and intuative manor.

Main script titled, `bird_scanner.R`, will batch run the bird-net model to analyze multiple wav files and output a table with the predicts species within each wave file analyzed. From there, using the `bird_checker.R` script will then analyze suspiscous calls predicted from the model by outputting a segment of the audio recording and a spectrogram.

From more information on using BirdNet and how the model works visit the Jounral Arcticle here: https://www.sciencedirect.com/science/article/pii/S1574954121000273.
