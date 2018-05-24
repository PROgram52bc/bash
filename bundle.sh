# usage: ./bundle.sh in_file1 in_file2 ... > out_script.sh
echo "# bash this file to extract files listed below:"
for i
do
	echo "# $i"
done
echo

for i
do
	echo extracting $i 1>&2 # printing process information to console
	echo "cat >$i <<'here is $i'" # cat the content into the file
	cat $i
	echo "here is $i"
	echo "chmod `stat -c %a $i` $i" # set permissions
	echo "touch -m -d \"`stat -c %y $i`\" $i" # set modification time
	echo "touch -a -d \"`stat -c %x $i`\" $i" # set access time
done
