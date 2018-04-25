#/bin/bash
# NOTES!! There is some problem in output when executing filenames with spaces. It is suggested to use arrays to store file names in the next version.
# This script finds all complete files in $DownloadDIR (default /home/wallet/Downloads")
# If a complete file is named "myfile.txt", then there is no file named "myfile.txt.part" in the same directory, which means it's being downloaded.
DownloadDIR="/home/wallet/Downloads"
string=$(for i in $1; do
        nodir=${i##*/}
        echo $nodir
        echo ${nodir%.*}
    done) # protected files
ncpltFiles=$(for i in $1; do
            nodir=${i##*/}
            echo ${nodir%.*}
        done) # non-complete file names
CurrentDIR=$PWD
cd $DownloadDIR
cpltFiles=$(ls -A| grep -vF "$string") # complete files ready to move
if [[ "$cpltFiles" ]]; then
    echo "$cpltFiles" | xargs -i mv {} $CurrentDIR && echo -e "File(s):\n$cpltFiles\nmoved to $CurrentDIR"
fi
echo -e "\nFile(s):\n$ncpltFiles\nare being downloaded thus not moved"
cd $CurrentDIR
