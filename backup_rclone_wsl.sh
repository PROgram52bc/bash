#!/bin/bash

################################################################
#  This script backs up a folder to google drive using rclone  #
################################################################

SOURCE="\\Users\\david\\Documents\\pdf_collection"
DESTINATION="gd:pdf_collection/"
RCLONE="/mnt/c/Users/david/.linux/bin/rclone.exe"

# switch the following two lines to ignore all hidden files/folders

$RCLONE copy --verbose --exclude='.*' --exclude='.*/**' --update --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s ${SOURCE} ${DESTINATION}

# rclone copy --exclude='.git' --exclude='.git/**' --update --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s ${SOURCE} ${DESTINATION}
