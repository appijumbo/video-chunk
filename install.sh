#! /bin/bash

# Title:    Video Chunker
# Date:     Created 20 October 2018
# Author:   Tom Ormiston

# Status:   alpha - you have been warned

# Description




#####################################################
# Constants
#####################################################
readonly version=0.1




#####################################################
# Global Variables
#####################################################
#declare foobar=""



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

mkdir -p videochunk
cd videochunk

# wget -O  xxxxxxxxxxxxxxxxxx  # setup the path and properly pull in files

mkdir -p assets clips-made scripts



# into a right place, pulling in files from github
# via wget or simlilar and moving them into those
# newly created directories 


}


######################################################
#  MAIN
######################################################
# 

checkDependances

setup_directory




