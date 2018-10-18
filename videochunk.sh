#! /bin/bash

# Title:    Video Chunker
# Date:     Created 20 October 2018
# Author:   Tom Ormiston

# Status:   alpha - you have been warned ! 

# Alternative: If you need somethig that just cuts video try VidCutter 
# https://github.com/ozmartian/vidcutter and under 'settings' enabling 'keep clip segments'. 
# Other editing tools reviewed at  https://opensource.com/article/18/4/new-state-video-editing-linux

# Description
# Splits up a long video into clips, with simple titling using a JSON as an Edit Decision List
# 
# When each clip follows a similar format, the aim is to quickly get the clips edited in bulk form. 
# Any titling and composition will be limited inorder to focus the user on getting the clips ready 
# to be published as quickly as possible.




#####################################################
# Constants
#####################################################
readonly VERSION="0.0.1"
readonly create_edl_script="create_EDL_v3.sh"
readonly make_edl_script="make_EDL_v1.sh"
readonly make_titles_script="make_titles_v1.sh"
readonly chunk_video_script="chunk_video_script_v1.sh"
readonly play_video_script="play_video_script_v1.sh"
readonly block_of_clips_script="play_video_script_v1.sh"
readonly CURR_DIR="$(dirname $0);"






#####################################################
# Global Variables
#####################################################
declare video_name=""
declare fps=0
declare scriptname=$0   # $0 is the name of the program
declare file=$1







######################################################
#  List help
######################################################
# 
#
function help_list(){
    cat <<EOF
Usage: configure [options]
Options: [defaults in brackets after descriptions]

Help options:

  -h
  --help                 Print this message


  --make-edl         Make an edit decision list (EDL) with 'in' and 'out' points  
  -E
                            $ videochunk --make-edl videoFilename    


  --make-titles      Make simple titles for a video (words, background and position)
  -T
                            $ videochunk --make-titles videoFilename -e EDLfilename
                            $ videochunk --make-titles videoFilename --edl EDLfilename
                            $ videochunk -T videoFilename -e EDLfilename
    


  -c                       Chunk a video
  --chunk-video

                            $ videochunk -c videoFilename -e EDLfilename
                            $ videochunk --chunk-video videoFilename --edl EDLfilename



  -t                        Add titles
  --titles
                            chunck a video into clips with titles

                            $ videochunk -c videoFilename -e EDLfilename -t TITLESfilename
                            $ videochunk --chunk-video videoFilename  --edl EDLfilename --titles TITLESfilename
    
                            Add titles to a single video

                            $ videochunk -c videoFilename -t TITLESfilename
                            $ videochunk --chunk-video videoFilename  --titles TITLESfilename


    
  -p                       Play
  --play
                            Play first 8 seconds
                            $ videochunk -p:f8 videoFilename -e EDLfilename
                            videochunk --play:f8 videoFilename --edl EDLfilename


                            Play last 12 seconds
                            $ videochunk -p:l12 videoFilename -e EDLfilename
                            $ videochunk --play:l12 videoFilename --edl EDLfilename


                            Play last 10 seconds with titles
                            $ videochunk -p:l12 videoFilename -e EDLfilename -t TITLESfilename
                            $ videochunk --play:l12 videoFilename --edl EDLfilename --titles TITLESfilename



  -b                       Add titles to a block of videos 
  --block-of-clips

                            $ videochunck -b directoryVideos/ -t TITLESfilename
                            $ videochunck --block-of-clips directoryVideos/ --titles TITLESfilename
    


  --version            version of videochunk
    


  -q                      Quiet - minimal logging
  
EOF
  exit 0
}





######################################################
#  Command Options
######################################################
# 
#
while getopts ":qcpET:h" opt; do
   case $opt in

   q )  
        echo "quiet -q" 
        ;;
        
   c )  
        echo "chunk video -c and $OPTARG is after" 
        ;;
        
   p )  
        echo "play video -p and $OPTARG is after" 
        ;;
        
   E )  
        echo "Make video titles -E and $OPTARG is after" 
        ;;
        
   T )  
        echo "Make video titles -T and $OPTARG is after" 
        ;;
   
   t )  
        echo "Add  titles -t and $OPTARG is after" 
        ;;   
        
        
   h )
        help_list 
        ;;
        
   \?)  
       echo "found $opt"
       ;;
       
    *)
        printf "\nInvalid argument\n"
        
   esac
done

shift $(($OPTIND - 1))   # removes all arguments that have been processed by getopts

echo "the remaining arguments are: $1 $2 $3"




######################################################
#  Read Edit Decision List Data
######################################################
# 
#
# Pull in edit decision list  data from JSON file 
# and store in local variable (user may have input 
# values previously, where they would be automatically 
# saved to the JSON)
function readEDL(){
    
    local theJSON=$(cat vchunkEDL/${video_name}.EDL.json)
    local num_of_clips=$( printf $theJSON | jq '.clips | length' ) 
    local clip_count=0
    local clip_title=""
    local in_minutes=0
    local in_seconds=0
    local in_hours=0
    local out_minutes=0
    local out_seconds=0
    local out_hours=0
    local in_total_in_seconds
    local out_total_in_seconds
    local duration=0
    local file_title=""
    local file_ex=""
    
    printf "\nREAD EDL\n============\n"
    
    
#     for row in $(printf "${sample}" | jq -r '.[] | @base64'); do
#         _jq() {
#         printf ${row} | base64 --decode | jq -r ${1}
#         }
#         done
        

         # loop to read in clip in-out times, calculate durations and print them with clip title
         
         
         for (( count=0; count<$num_of_clips; count++))
            do
                printf "\n----------------------------------------------------\n"
                
                clip_title=$(printf $theJSON | jq ".clips[$count].title")
                in_hours=$(printf $theJSON | jq ".clips[$count].cutTimes.inTime.hours")
                in_minutes=$(printf $theJSON | jq ".clips[$count].cutTimes.inTime.minutes")
                in_seconds=$(printf $theJSON | jq ".clips[$count].cutTimes.inTime.seconds")
                
                printf "\nTitle $clip_tile"
                printf "\nIN:   hours = ${in_hours}        minutes = ${in_minutes}        sec = ${in_seconds}" 
                
                out_hours=$(printf $theJSON | jq ".clips[$count].cutTimes.outTime.hours")
                out_minutes=$(printf $theJSON | jq ".clips[$count].cutTimes.outTime.minutes")
                out_seconds=$(printf $theJSON | jq ".clips[$count].cutTimes.outTime.seconds")
                
                printf "\nOUT:  hours = ${out_hours}        minutes = ${out_minutes}        sec = ${out_seconds}" 
                
#              calculate the durations for ffmpeg

                let "in_total_in_seconds = (in_hours*3600)+(in_minutes*60)+in_seconds"
                # in_total_in_seconds=$(($((in_hours*3600))+$((in_minutes*60))+$in_seconds))
                
                printf "\nIn-time (in seconds) = ${in_total_in_seconds}"
                
                let "out_total_in_seconds = (out_hours*3600)+(out_minutes*60)+out_seconds"
                # out_total_in_seconds=$(( $((out_hours*3600))+$((out_minutes*60))+out_seconds))
                printf "\nOut-time (in seconds) = ${out_total_in_seconds}\n"  
                
                let "duration = out_total_in_seconds - in_total_in_seconds"
                printf "\nClip length (in seconds) = ${duration}"
                
                
#             ************  CHUNK THE VIDEO   *************

                file_title=`printf "\n${file}" | cut -d'.' -f1`
                file_ex=`printf "\n${file}" | cut -d'.' -f2`
                ffmpeg -v quiet -i $file -ss $in_hours:$in_minutes:$in_seconds -t $duration $file_title_$clip_tile.$file_ex
                
            done 
}





######################################################
#  
######################################################
# 
#
function checkEDL(){
    if [ "$file" != "" ]
    then
        mkdir -p vchunkEDL
        if [ -f  vchunkEDL/$file.EDL.json ]
            then
                printf "\nUse existing EDL file\n"
                inputEDL
            else
                # Create an EDL file
                printf "created an EDL file\n"
                ./$create_edl_script $file
        fi
    else
        printf "\n sorry you need to  provide a video filename eg $ ./videocunk_15.sh videofile.mp4\n"
        exit 1
    fi
}



printf "Video Chunk --> version $version"

setup_directory



