# Bird_Scanner

![image](https://user-images.githubusercontent.com/54585357/192024913-dfe51948-b297-4043-bfef-e110efe34690.png)

These scripts and gui are to develop an R ecosystem and eventual application to run the Bird-Net Algorithm in R

These scripts are modified on the NSNSDAcoutics R package that leverages the Bird-Net tensorflow model to extract avian calls through wav files in a very streamline and intuative manor.

Main scripts will batch run the bird-net model to analyze multiple wav files and output a table with the predicts species within each wave file analyzed.

@article{kahl2021birdnet,
  title={BirdNET: A deep learning solution for avian diversity monitoring},
  author={Kahl, Stefan and Wood, Connor M and Eibl, Maximilian and Klinck, Holger},
  journal={Ecological Informatics},
  volume={61},
  pages={101236},
  year={2021},
  publisher={Elsevier}
}
