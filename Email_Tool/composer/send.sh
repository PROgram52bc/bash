#!/bin/bash
# - use a folder to store contents(e.g. confirm/1.txt, confirm/2.txt...)
# √ use a result file to record if last sending has succeeded
# √ use an associative array inside to record sending results(e.g. result[1]='y')
# - use y,n,a,q? to confirm before sending every email
# bash code to send email:
if test $# != 1; then echo "usage: ./send.sh folder_of_letters"
	exit
elif test ! -d $1; then echo no directory $1
	exit
fi

IFS=,
FOLDER=${1%/} # remove the final /
DATAFILE=${FOLDER}/data.csv
RESULTFILE=$1/result.csv
SUBJECT_DEFAULT=${FOLDER%_letters}
SUBJECT_ZH=$(cat $FOLDER/subject_zh.txt) 2>/dev/null
SUBJECT_EN=$(cat $FOLDER/subject_en.txt) 2>/dev/null
declare -A resultArr
confirm=y
if test -f ${RESULTFILE}
then
	while read num result
	do resultArr[$num]=$result; 
	done < ${RESULTFILE}
else
	while read num GARBAGE
	do resultArr[$num]=n; 
	done < ${DATAFILE}
fi
while read num address name sal isOld isClose isMoney isEng Garbage; do
	if test "${resultArr[$num]}" != y && 
		[[ ${num} =~ ^[0-9]+$ ]]
	then
		SUBJECT="$([ "$isEng" = y ] && echo ${SUBJECT_EN:-$SUBJECT_DEFAULT} || echo ${SUBJECT_ZH:-$SUBJECT_DEFAULT})"
		if test $confirm = y; then
			echo "To: $name, $address"
			echo "Subject: $SUBJECT"
			cat ${FOLDER}/${num}.txt
			echo "send right now? (y/a/n/q)"
			read response < /dev/tty
			# echo "Response: $response"
			case $response in
				a)
					confirm=n
					;;
				y)
					;;
				n)
					continue
					;;
				*)
					break
					;;
			esac
		fi
		#cat ${FOLDER}/${num}.txt | mailx -s "=?utf-8?B?$(echo 代祷邀请 | base64)?=" ${address}
		cat ${FOLDER}/${num}.txt | mailx -s $SUBJECT ${address}
		retval=$?
		if test $retval = 0; then
			resultArr[$num]=y
			echo email sent to $name, $address
		else
			echo email to $name, $address was not sent. return value: $retval
		fi
	fi
done < ${DATAFILE} 

# write resultArr to $RESULTFILE
for key in ${!resultArr[@]}; do
	echo "${key},${resultArr[$key]}"
done > ${RESULTFILE}
