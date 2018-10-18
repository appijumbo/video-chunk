# TODO list

## --------- Features: MUST have/do

* remove the 'main' loop from the videochunk command
  
* To be able to create a in-out clip points that then create a JSON file with clip filenames. This should be a seperate script

* Implement a CML 'option/flag' based structure

* Have a top level script that uses a case (maybe) to call other cripts on these options

* A seperate install script, to pull down (eventually ) the scripts, create directory structure and put files in the correct place

## ------ Code Quality & Structure: MUST have/do

* Global Variables at top

* Resturucture functions, so more 'namespace' control

* Add comments; a few links, and where necessary and explanations to yourself

* Remove the sample JSON file

* --help flag

* sanity check for commands

* Create a dir for video clips

* Work independantly of current directory

* -- q provide a quiet option

* Have an error codes script that contains just error codes

* Allow for exiting using these error codes

* Clean up after exiting on error

* Print newline \n when script completes to indicate finished

* Simple titler, easily repeats for a sequence of clips. Make it easy to have .png images (with alpha channel) put into a clip at the begining, end or duration of the clip

* These images could be from a url, then via curl or wget downloaded and via imgagik scaled. Could have the same image repeating, or a different image for each clip. This could be expanded later to generate an image from HTML

* Background - For title

* Blur + low contrast + low opacity Option

* Presenter/ Slide mode: Have Simple Image x-axis shift that would put the presenter at the edge of the screen, then automaticaly scale and overlay a video of the slide.

* Could be expanded later to automatical create a slide video pased on a .png of the slides and in-out JSON data for each slide

* Fast and Easy Presentation/Event Uploading: for getting presentations (like the KDE event) out fast. After chunking video easily allow upload to Youtube or Peertube account

* Database of free Pics: Use the database and wget (no api?) to get pics for background

* Consider site also used by KDE shop and Linux background desktop ones

## --------- Code Quality & Structure: nice to have/do

* indicate progression with animations
