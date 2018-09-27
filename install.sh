#! /bin/bash

# Title:    Video Chunker
# Date:     Created 20 October 2018
# Author:   Tom Ormiston

# Status:   alpha - you have been warned

# Description



######################################################
#  Install jq a bash JSON tool
######################################################
# 
#
function DetectDistroinstallJq(){
# only works for Ubuntu for now

local distro=$(uname -v | tr '[:upper:]' '[:lower:]' )

case $distro in
    *"ubuntu"* | *"debian"*)
        printf "\nUbuntu/Debian detected"
        sudo apt install jq
        clear
        ;;
        
    *"freebsd"*)
        printf "\nFreeBSD detected"
        #pkg install jq
        # clear
        ;;
        
   *"fedora"*)
        printf "\nFedora detected"
        #sudo dnf install jq
        # clear
        ;;
        
   *"opensuse"*)
        printf "\nOpenSUSE detected"
        #sudo zypper install jq
        # clear
        ;;
        
   *"Arch"*)
        printf "\nArch detected"Resturuvture to a more typical 'option/ flag ' based usaged
        #sudo pacman -Sy jq
        # clear
        ;;
        
    *"Darwin"*)
        printf "\nMacOS detected: Will try installing via homebrew\n If this fails please install homebrew"
        #brew install jq
        # clear
        ;;
        
    *)
        printf "\nUnkown distro\nPlease manualy install jq\n refer to jq download notes at https://stedolan.github.io/jq/download/"
        exit 1
        ;;
esac
}





######################################################
#  Check dependances are installed
######################################################
# 
#
function checkDependances(){
# For easy JSON parsing in bash, check that 'jq' is installed
# https://stedolan.github.io/jq/manual/
# https://medium.com/cameron-nokes/working-with-json-in-bash-using-jq-13d76d307c4

if [ "$(which jq)" = "" ]
    then
        printf "\nThis script requires jq, a JSON parsing library for bash\n
        please allow it to install"
        DetectDistroinstallJq
fi
}





######################################################
#  Set up Directories
######################################################
# 
# for now just create seperate 'videoChunk' folder with
# for JSON assets (eg EDL, title JSONS) and video files
# wherever the installation file is put

function setup_directory(){

    printf "\n--->\ndownloading files from Github and giving them execute permissions\n"
    # Pull in files from github and chmod them
    wget https://github.com/appijumbo/video-chunk/archive/master.zip -O videochunk.zip

    unzip videochunk.zip

    rm videochunk.zip

    cd video-chunk-master/

    printf "\nPlease give permissions to allow code to execute\n"

    sudo chmod +x install.sh && $(for file in scripts/*; do chmod +x $file; done)

    printf "\nScripts installed\nPlease run as\n    $ ./videochunk.sh\n"

   # In future set up $PATH and putting them into a /bin 
}


######################################################
#  MAIN
######################################################
# 

setup_directory
checkDependances





