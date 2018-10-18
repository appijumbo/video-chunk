#! /bin/bash

# Title:    Video Chunker Installer
# Date:     Created 20 October 2018
# Author:   Tom Ormiston

# Status:   very alpha - you have been warned



######################################################
#  VARIABLES
######################################################
readonly VERSION="0.0.1"
readonly LOCAL_SBIN_VIDEOCHUNK="/usr/local/sbin/videochunk/"
declare home_directory="${HOME}"



######################################################
#  USER SET VARIABLES
######################################################
declare distro_repo_command="apt install"   # default is 'apt install'


function check_jq_n_unzip(){

    if [ "$(which jq)" = "" ]; 
        then
            printf "\nThis script requires jq, a JSON parsing library for bash\nplease allow it to install\n"
            sudo ${distro_repo_command} jq
        else printf "jq installed"
    fi

    if [ "$(which unzip)" = "" ]; 
        then
            printf "\nThis script requires unzip\nplease allow it to install\n"
            sudo ${distro_repo_command} unzip
        else printf "unzip installed"
    fi
}


#-----------------------------------------------------
# Aim: Determine distro then check JSON tool 'jq' and 'unzip' installed
# Globals: none
# Arguments:distro
# Returns: none
# NOTES: 
#   only works for Ubuntu for now
#   For easy JSON parsing in bash, check that 'jq' is installed
#   https://stedolan.github.io/jq/manual/
#   https://medium.com/cameron-nokes/working-with-json-in-bash-using-jq-13d76d307c4
#   Check unzip is installed 
#-----------------------------------------------------
function detect_distro(){

local distro=$(uname -v | tr '[:upper:]' '[:lower:]' )

case $distro in
    *"ubuntu"* | *"debian"*)
        printf "\nUbuntu/Debian detected"
        distro_repo_command="apt install"
        check_jq_n_unzip
        clear
        ;;
        
    *"freebsd"*)
        printf "\nFreeBSD detected"
        # distro_repo_command="pkg install"
        # check_jq_n_unzip
        # clear
        ;;
        
   *"fedora"*)
        # distro_repo_command="dnf install"
        # check_jq_n_unzip
        # clear
        ;;
        
   *"opensuse"*)
        printf "\nOpenSUSE detected"
        # distro_repo_command="zypper install"
        # check_jq_n_unzip
        # clear
        ;;
        
   *"Arch"*)
        printf "\nArch detected"
        # distro_repo_command="pacman -Sy"
        # check_jq_n_unzip
        # clear
        ;;
        
    *"Darwin"*)
        printf "\nMacOS detected: Will try installing via homebrew\n If this fails please install homebrew"
        # distro_repo_command="brew install"
        # check_jq_n_unzip  #  - but Mac so may no be unzip
        # clear
        ;;
        
    *)
        printf "\nUnkown distro\nPlease manualy install jq\n refer to jq download notes at https://stedolan.github.io/jq/download/"
        exit 1
        ;;
esac
}





#-----------------------------------------------------
# Aim: Download from Gihub via gitclone or wget and install
# Globals: none
# Arguments:none
# Returns: none
#-----------------------------------------------------
function download_n_install(){
    printf "\n--->\ndownloading files from Github and giving them execute permissions\nPlease give password for ${home_users} to allow code to execute\n"

    printf "\nInstalling in ${home_directory}\n"
    
    LOCAL_VIDEOCHUNK="$home_directory/videochunk"
    INSTALL_SBIN="/usr/local/sbin/"
    sudo mkdir -p $LOCAL_SBIN_VIDEOCHUNK

    # usr/local/sbin will be the binary PATH

    # Pull in files from github and chmod them
    sudo wget https://github.com/appijumbo/video-chunk/archive/master.zip -O $LOCAL_SBIN_VIDEOCHUNK/videochunk.zip

    # check is something has downloaded
    if [ -e "$LOCAL_SBIN_VIDEOCHUNK/videochunk.zip" ]; then

        # check the integrity of what has downloaded
        if [ $(unzip -tq videochunk.zip | grep "No errors detected in compressed data of videochunk.zip.") ]; 
            then
                # unzip, overwritting any previous files (in case they we a corrupted version), and in quiet mode
                sudo unzip -oq $LOCAL_SBIN_VIDEOCHUNK/videochunk.zip
                
                # clean up
                sudo rm "$LOCAL_SBIN_VIDEOCHUNK/videochunk.zip"

                cd "$LOCAL_SBIN_VIDEOCHUNK/video-chunk-master"
                
                # Ensure the owner and group on all files and directories (ie recursivley) and with 'no-defference' (ie do affect any symbolic links) is the same as the user who downloaded it
                sudo chown "$(whoami)":"$(whoami)" -hR "$LOCAL_SBIN_VIDEOCHUNK/video-chunk-master"
                sudo chmod +x videochunk.sh

                # Make the .sh files executable. Can do this with for loop(commented out) or xargs.
                #for file in scripts/*; do sudo chmod +x $file; done
                ls -1 $LOCAL_SBIN_VIDEOCHUNK/video-chunk-master/scripts/*.sh | xargs -I{} sudo chmod +x '{}'

                printf "\nScripts installed\nPlease run as\n    $ ./videochunk.sh\n"


    
            else 
                printf "Sorry the download of VideoChunk.zip appears to be corrupted\n. Please try again\n"
                exit 22
        fi
    else
        printf "Sorry, we seem to have problems downloading Video Chunk using Wget. Please try again later \n"
        exit 33

    fi


    
}


#-----------------------------------------------------
# Aim: Set up Directories
# Globals: none
# Arguments:none
# Returns: none
# Notes
#   for now just create seperate 'videoChunk' folder with
#   for JSON assets (eg EDL, title JSONS) and video files
#   wherever the installation file is put
#-----------------------------------------------------
function setup_directory_n_install(){
    local home_users=$(cat /etc/passwd | grep /home | grep -v cups | grep -v syslog | cut -d: -f1)

    printf "Your current home users are belived to be --> ${home_users}\nYou are logged in as $(whoami)\n"

    # Find out if in root or a 'home' directory
    if [ $home_directory == "/root" ]
    then
        printf "\nPlease ensure you are in your desired home directory, not root,and\nre-execute $ bash install.sh    \nThankyou.\nYour user options are believed to be ${home_users}\n"
        exit 11
    else
       download_n_install

    fi
    
}


######################################################
#  MAIN
######################################################

setup_directory
detect_distro
setup_directory_n_install  

