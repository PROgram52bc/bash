#!/bin/bash

# 短宣邮件小程序：
# e.g.
# 编号	地址			姓名			称呼  	老代祷者?  	朋友? 	钱?	英语?
# 1,	xxx@xxx.com,	谢老师一家,		你们,	y,			n,		y,	n
# 
# bash code to compose message:
if test $# != 1; then echo "usage: ./invitation.sh data.csv"
	exit
fi
DATAFILE=$1
FOLDER=${0%.sh}_letters
SUBJECT_ZH="代祷邀请"
SUBJECT_EN="Mission Support Invitation"
IFS=,
if [ ! -d $FOLDER ]; then
	mkdir $FOLDER
else
	rm $FOLDER/*
fi
cat $DATAFILE | while read num address name sal isOld isClose isMoney isEng Garbage
do
	# if "num" is a valid number (eliminate the title)
	if [[ ${num} =~ ^[0-9]+$ ]]; then 
		if [ "$isEng" != y ]; then
			cat > ${FOLDER}/${num}.txt << HERE
${name}${sal}好，
$([ "$isOld" = y ] && echo $([ "$isClose" = y ] && echo 真的很谢谢 || echo 非常感谢)${sal}在4月份对我参加的短宣的代祷和支持！)我的学校在明年的1月$([ "$isOld" = y ] && echo 还)会组织一次到南美的短宣，主要针对计算机科学学生，想为在南美的人们提供一些技术上的帮助和服侍。
${sal}的代祷$([ "$isOld" = y ] && echo 同样)会带给我很大的帮助和鼓励-- 如果${sal}$([ "$isOld" = y ] && echo 还愿意继续 || echo 愿意)为我代祷$([ "$isMoney" = y ] && echo （或提供经济上的帮助）)，请回复我（“好的”即可），我会随时将最新的一些进展发给${sal}，谢谢！
邓皓天
HERE

		else
			cat > ${FOLDER}/${num}.txt << HERE
Hi ${name},
$([ "$isOld" = y ] && echo "I really appreciated your prayer and support during the mission trip that I attended in April! ")It happened that I will be participating in $([ "$isOld" = y ] && echo another || echo a) mission trip to South America in January 2019, which is arranged mainly for Computer Science students, who will then be serving the people there with technical supports.
Your prayer will certainly bring me encouragements and strengths in every subtle way-- if you would like to $([ "$isOld" = y ] && echo continue praying || echo pray) for me$([ "$isMoney" = y ] && echo " (or to support me financially)"), please reply to this email, so that I can forward you any progress of the trip. Thanks!
David Deng
HERE
		fi
	fi
done
cp $DATAFILE $FOLDER/data.csv
echo $SUBJECT_EN > $FOLDER/subject_en.txt
echo $SUBJECT_ZH > $FOLDER/subject_zh.txt
