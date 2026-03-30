# Features project

This is part of an ongoing research project where I wanted to know how English speakers perceive the /y-u/ contrast in German (e.g. Bluten/Blüten). The experient has two tasks: discrimination, where listeners must listen to two words and need to decide if they are the same or different, and identification, where listeners need to click on a picture according to the word that they heard.

This experiment was hosted on Pavlovia in 2024, but can be run locally -the relevant bits that connected with Pavlovia were commented out.

If you want to run a similar experiment, feel free to take parts of this code, but make sure to adapt your code to your needs, file structure, experimental setting, etc.

The structure is as follows:

## Experiment files

1. The loose files:
   
- The experiment can be launched from **index.html**.
- Files **info.odt** and **info.pdf** contain the participant information sheet.
- **jspsych.css** is the style sheet of the experiment.
- 
2. The folders:
  
- **data** contains the data files that Pavlovia created after each participant.
- **js** and **jspsych** are folders that contain the jsPsych plugin.
- **audio_projekt** contains the audio files that were presented as stimuli throughout the experiment.
- **pics** contains the images that participants had to click on.
  
## Analysis files

The last folder is **Features2_analysis**, which contains R scripts and other files to put together a Quarto presentation with the results of the experiment.

- **data** is again the data gathered from the experiment.
- **jobtalk_files** are files created by Quarto.
- All .png files are some images added to the presentation.
- All .csv files are output files from the .R scripts that cleaned the data. Some lines in these scripts also show up in **jobtalk.qmd**.
- **jobtalk.qmd** is the Quarto presentation file. It generates the file **jobtalk.html**, which reports the results of the experiment.

## If you want to use these scripts:

- You can run the experiment locally (e.g. in a recording booth) for a more controlled setting, but you can also do this online. You'll need some server space for that -Pavlovia charges about 50 pence per participant, but you can also run it in your own server space. Check the jsPsych documentation for that because you might need to write some extra code to link the experiment to a database (I used MySQL in a previous version of this experiment and had to add a PHP script for integration -but don't worry, a lot of this is very well explained in the jsPsych docs).
- Note that some code in the **index.html** file should be commented in/out depending on whether you want to run the experiment online or locally.
- (Un)fortunately, jsPshych is constantly changing, so some code may be difficult to update if you leave too much time between writing your code and the final setup :(
