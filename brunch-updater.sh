#!/bin/bash

cat << "EOF"
+---------------------------------------------------------------+
|                                                               |
| .--.                  .      .   .         .      .           |
| |   )                 |      |   |         |     _|_          |
| |--: .--..  . .--. .-.|--.   |   |.,-.  .-.| .-.  |  .-. .--. |
| |   )|   |  | |  |(   |  |   :   ;|   )(   |(   ) | (.-' |    |
| '--' '   `--`-'  `-`-''  `-   `-' |`-'  `-'`-`-'`-`-'`--''    |
|                                   |                           |
+---------------------------------------------------------------+
| Use with caution!                       Updater Version v0.2  |
+---------------------------------------------------------------+

EOF

    main() {
        while true; do
        RELEASE=$(cat /etc/brunch_version)
        CURRENT=$(awk '{print $4}' < /etc/brunch_version)
        PS3=" >> "
        BOOKMARK=$(pwd)
        BRUNCH=
        METHOD=
        RECOVERY=
        if [ $BOOKMARK != ~/Downloads ]; then
        cd ~/Downloads
        fi
        getfiles
        done
        cleanexit
    }
    
    getfiles() {
        echo "[✓] Searching for Brunch update tar.gz files..."
        FILES="$(ls -ArR brunch*.tar.gz 2> /dev/null)"
        if [ -z  "$FILES" ] ; then
            getupdate    
        else
            countfiles
        fi
    }
    
    countfiles() {
        FILECOUNT=$(ls -AR brunch*.tar.gz* 2> /dev/null | wc -l)
        if [ $FILECOUNT = 1 ]; then
            echo "[✓] Brunch update file found!"
            BRUNCH=$FILES
            sanitycheck
            cleanexit
        else
            echo "Files found!"
            selectbrunch
        fi
    }
    
    selectbrunch() {
        echo ""
        echo "Enter the number of the update you want to use."
        echo "The first option (1) should be the most recent."
        echo "Press Ctrl + C if you would like to quit."
        echo ""
        select BRUNCH in ${FILES}; do
        if [ -z "$BRUNCH" ] ; then
           echo "[ERROR] Invalid option"
           selectbrunch
        else
            echo "[✓] Brunch update file selected."
            sanitycheck
        fi
        cleanexit
        done
    }
    
    sanitycheck() {
        while true; do
            echo "Current version: $RELEASE"
            echo "Target version: $BRUNCH"
            if [[ $BRUNCH =~ .*"$CURRENT".* ]] ; then
                echo "[WARNING] You are already on the current version."
                echo "Do you want to update anyway?"
                    read -p " >> " yn
                    case $yn in
                        [Yy]* ) checkchrome; break;;
                        [Nn]* ) echo "Update cancelled!"; cleanexit;;
                        * ) echo "[ERROR] Invalid option, Please type yes or no.";;
                    esac
            else
            echo "Update with this release? (y/n)"
            read -p " >> " yn
            case $yn in
                [Yy]* ) checkchrome; break;;
                [Nn]* ) echo "Update cancelled!"; cleanexit;;
                * ) echo "[ERROR] Invalid option, Please type yes or no.";;
            esac
            fi
        done
    }

    finalcheck() {
        while true; do
            echo "Update both Chrome OS and Brunch? (y/n)"
            read -p " >> " yn
            case $yn in
                [Yy]* ) updatechrome; break;;
                [Nn]* ) echo "Update cancelled!"; cleanexit;;
                * ) echo "[ERROR] Invalid option, Please type yes or no.";;
            esac
        done
    }
    
    checkchrome() {
        while true; do
            CHROME="$(ls -ArR chromeos*.bin 2> /dev/null)"
            if [ -z "$CHROME" ] ; then
                updatebrunch
            else
                echo "[✓] Chrome OS Recovery found!"
                echo "Would you like to update Chrome OS as well?"
                echo "Type Yes to update Chrome OS and Brunch."
                echo "Type No to update just the Brunch Framework."
                echo "Press Ctrl + C if you would like to quit."
            read -p " >> " yn
            case $yn in
                [Yy]* ) chromecount; break;;
                [Nn]* ) updatebrunch; break;;
                * ) echo "[ERROR] Invalid option, Please type yes or no.";;
            esac
            cleanexit
            fi
        done
    }
    
    chromecount() {
        CROSCOUNT=$(ls -AR chromeos*.bin 2> /dev/null | wc -l)
        if [ $CROSCOUNT = 1 ]; then
            finalcheck
            cleanexit
        else
            selectchrome
        fi
    }
    
    selectchrome() {
        echo ""
        echo "Enter the number of the recovery you want to use."
        echo "Press Ctrl + C if you would like to quit."
        echo ""
        select RECOVERY in ${CHROME}; do
        if [ -z "$RECOVERY" ] ; then
           echo "[ERROR] Invalid option"
           selectchrome
        else
            echo "[✓] Chrome Recovery file selected."
            finalcheck
        fi
        cleanexit
        done
    }
    
    getupdate() {
        echo "[ERROR] A Brunch update file was not found in ~/Downloads"
        echo ""
        echo "What would you like to do?"
        echo "Select one of the following options."
        echo "Press Ctrl + C if you would like to quit."
        echo ""
        select METHOD in "Download the newest release automatically" "Visit the releases page"; do
        if [[ $METHOD =~ .*"Download".* ]]; then
            getbrunch
        elif [[ $METHOD =~ .*"Visit".* ]]; then
            echo ""
            printf '\e]8;;https://github.com/sebanc/brunch/releases\e\\ >> Click here to visit the release page << \e]8;;\e\\\n'
            echo ""
            echo "Or you can visit: https://github.com/sebanc/brunch/releases"
            echo "Please run this script again after your download finishes."
            cleanexit
        else
            echo "[ERROR] Invalid option"
            echo "$METHOD"
            getupdate
        fi
        cleanexit
        done
    }    
    
    updatebrunch() {
        echo "[✓] Launching Brunch update script, please wait..."
        sudo chromeos-update -f ~/Downloads/$BRUNCH
        cleanexit
    }
        
    updatechrome() {
        echo "[✓] Launching Brunch update script, please wait..."
        sudo chromeos-update -r ~/Downloads/$RECOVERY -f ~/Downloads/$BRUNCH
        cleanexit
    }
    
    getbrunch() {
        wget -q --show-progress $(curl -s https://api.github.com/repos/sebanc/brunch/releases/latest | grep 'browser_' | cut -d\" -f4)
        echo "        Brunch update downloaded! Refreshing, please wait..."
        echo ""
        getfiles
    }
        
    cleanexit() {
        echo "[X] Exiting..."
        PS3=""
        cd $BOOKMARK
        exit
    }
    
main
