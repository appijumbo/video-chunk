# Video Chunker

To Install:
``$ wget https://raw.githubusercontent.com/appijumbo/video-chunk/master/install.sh``

``$ bash install.sh``

Welcome and thank you for trying out videoChunker.

Status: VERY alpha!

## Basics

The esence of the video chunker is very simply to apply a JSON (or similar) data object to direct an ffmpeg script.

The basic idea was to cut a very long (>10 hrs) video by just having 'in' and 'out' edit points stored in a JSON and then loop over these points with ffmpeg creating a new clip.

By keeping the creation of the edit decision list (EDL) as a seperate program/script one will be able to see how in furture this could be generated by a different, more GUI based program.

### 'Why a terminal based solution?'

By focusing on a terminal based solution we focus on the need to batch process a video or block (collection) of videos.

Speed and simplicity are aims, hence a title will be a simple background image and text chosen by the user. however positioning and font etc will not be an option.

It is also hoped that by keeping terminal focused at least in the initial development, this will not destract into GUI issues at least untill the structure of the code is more solid.

## Use case examples

### Very Long (>10 hours) Screen Cast

A long screen cast needs to be cut up into individual clips.
Only basic titling and clipe filenames are needed they may follow a 'Part 1, Part 2'
or similar sequenial format. Ideally this should be easy to set up.

### Slide Presentation Event

This is similar to the screen cast, but additionaly each presenter is stood presenting to
the audience. The Video Chunker should allow the presenter to just be shown on the edge
of the screen to give a 'live' feel and the rest of the screen a video cast of there slides
recordered live as they present [via OBS for example] and mixed in.
Frame accuaracy is not the concern, but a viewer should be easily able to see the slides and hear the speaker in reasonable synch.

Multiple videos
Eventually will have a flag option that indicates a directory of files to be batched processed
The main 'chunking' has already been done

## Directory Structure

``videochunk/

                    |
                    | README
                    |
                    | videochunk.sh  main geopt command choice, directs to correct command script
                    |
                    | install.sh     seperate installation script-
                    |                will create this directory structure and check dependances are installed
                    |
                    |
                    | scripts/       directory contains the different command scripts; examples include:-
                    |
                    |       |
                    |       |   make-edl.sh
                    |       |
                    |       |   make-titles.sh
                    |       |
                    |       |   slideshow-transform.sh
                    |       |
                    |       |   chunk-video.sh
                    |       |
                    |       |   add-titles.sh
                    |       |
                    |       |   play-video.sh
                    |       |
                    |       |   block-of-clips.sh
                    |
                    |
                    | assets/   directory holds edit decision list and titles JSONs for example
                    |       |
                    |       |  edl_JSON/
                    |       |
                    |       |  titles_JSON/
                    |
                    |
                    | clips-made/   created videos``

### Command Structure

Note : This isn't funtioning yet, but is how it might/should work

Make an edit decision list (EDL) for a video ie 'in' and 'out' points

``$ videochunk --make-edl videoFilename``

``$ videochunk -E videoFilename``

Make simple titles for a video (words, background and position)

``$ videochunk --make-titles videoFilename -e EDLfilename``

``$ videochunk --make-titles videoFilename --edl EDLfilename``

``$ videochunk -T videoFilename -e EDLfilename``

Chunk a video into

``$ videochunk -c videoFilename -e EDLfilename``

``$ videochunk --chunk-video videoFilename --edl EDLfilename``

chunck a video into clips with titles 't'

``$ videochunk -c videoFilename -e EDLfilename -t TITLESfilename``

``$ videochunk --chunk-video videoFilename  --edl EDLfilename --titles TITLESfilename``

Add titles 't' to a single video

``$ videochunk -c videoFilename -t TITLESfilename``

``$ videochunk --chunk-video videoFilename  --titles TITLESfilename``

Play first 8 seconds

``$ videochunk -p:f8 videoFilename -e EDLfilename``

``$ videochunk --play:f8 videoFilename --edl EDLfilename``

Play last 12 seconds

``$ videochunk -p:l12 videoFilename -e EDLfilename``

``$ videochunk --play:l12 videoFilename --edl EDLfilename``

Play last 10 seconds with titles

``$ videochunk -p:l12 videoFilename -e EDLfilename -t TITLESfilename``

``$ videochunk --play:l12 videoFilename --edl EDLfilename --titles TITLESfilename``

Add titles to a 'block' of videos
``$ videochunck -b directoryVideos/ -t TITLESfilename``

``$ videochunck --block-of-clips directoryVideos/ --titles TITLESfilename``

Version

``$ videochunk --version``

Quiet

``$ videochunk -q``

Help

``$ videochunk -h``

``$ videochunk --help``
