#!/bin/bash
# This script moves all files in ~/Download folder into the current directory. It is often used after some files are downloaded.
DownloadDIR=/home/wallet/Downloads
files="$(ls -A $DownloadDIR)"
isDownloading="$(find $DownloadDIR -maxdepth 1 -mindepth 1 -name "*.part")"
if [[ -n "$isDownloading" ]]; then
    /usr/local/bin/select_transfer.sh "$isDownloading"
elif [[ -n "$files" ]]; then
    mv ~/Downloads/* . && echo -e "File(s):\n$files\nmoved to $PWD"
else
    echo "Folder ~/Downloads is empty"
fi
