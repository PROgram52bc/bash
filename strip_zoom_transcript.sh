#!/bin/bash

declare -A names=(
["Kara Fu: "]="家宁：" 
["Haotian Deng: "]="皓天："
)


str="$(sed '/^[0-9]/d;/^\s*$/d' $1)"
# echo "$str"

# # Testing
# str="Haotian Deng: 看起来就到
# Kara Fu: Huh.
# Haotian Deng: 我们要猜一个吗？
# Kara Fu: Huh.
# Haotian Deng: Just。我觉得理发就行，可以跟中午都一样。
# Kara Fu: 哎，你跟中文的一样一模一样吗？
# Haotian Deng: 对啊。
# Kara Fu: 没事儿，那我就给这个这个吧，自己开一个。
# Haotian Deng: 对，我觉得可以。
# Kara Fu: 哎，不好意思啊，我这锅太不给力了。
# Haotian Deng: 啊，又不行了。
# Kara Fu: 拜拜。
# Kara Fu: 没有。我说我刚才这个锅耶。
# Kara Fu: 拜拜。
# Kara Fu: 没有。我说我刚才这个锅耶。
# Haotian Deng: 对，但这个连的同一个电源的这个灯没事儿。
# Haotian Deng: 就是高不行。
# Haotian Deng: 就是高不行。
# Kara Fu: 哎，没关系，"

echo "$str"

for name in "${!names[@]}"; do
	# echo "=======$name========"
	str="$(echo "$str" | sed 's/\r//g')"

	# Collapse heading
	# :l 				set label l,
	# $!N				except for last line, append next line to pattern space
	# s/.../.../		try to remove duplicate header
	# t l 				if matched (t), jump to l
	# p; d				otherwise, print the first line and delete it, restart from beginning

	str="$(echo "$str" | 
		sed -rn ":l;
			\$!N;
			s/^(${name}[^\n]*)\n${name}/\\1/;
			t l;
			P; D")"
	
	# Replace key with value
	str="$(echo "$str" | sed "s/^${name}/${names[$name]}/")"
	# echo "$str"
	echo "======================"
done
echo "$str"
