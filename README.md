# Bird_Scanner

![image](./img/logo_bird_scanner.png)

These scripts and workflow (<https://jkauphus.github.io/Bird_Scanner/>) are to develop an R ecosystem and eventual application to run the BirdNET Algorithm in R.

These scripts are modified to use the [birdnetlib](https://joeweiss.github.io/birdnetlib/api/) conda package, which is an API to the latest [BirdNET-Analyzer](https://github.com/kahst/BirdNET-Analyzer/tree/main) functions and convert its functions to R to extract avian calls through wav files in a very streamline and intuitive manor.

Main script titled, `bird_scanner.R`, will batch run BirdNET to analyze multiple wav files and output a table with the predicted species within each wav file analyzed. From there, using the `bird_checker.R` script will analyze suspicious calls predicted from BirdNET by outputting a segment of the audio recording and a spectrogram.

From more information on using BirdNET and how the model works visit the Journal Article here: <https://www.sciencedirect.com/science/article/pii/S1574954121000273>.
