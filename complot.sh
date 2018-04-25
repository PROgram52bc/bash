#/bin/bash
helpinfo="complot.sh [opt]\n
[opt]:\n
-h print help info\n
-c customize(copy the script to current directory)\n"
if [ $1 == "-h" ]
then
    echo -e $helpinfo
elif [ $1 == "-c" ]
then
    cdir=${PWD##*/}
    cp /usr/local/bin/complot.sh ./complot_${cdir}.sh && echo "complot_${cdir}.sh created!"
else
    string=${1##*_}
    string=${string%%.*}
    graph -T svg -C -F "HersheySerif" "$@" > combined_$string.svg
    display -density 144 $PWD/combined_$string.svg
fi
