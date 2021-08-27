#!/bin/bash
GIT_TOKEN=`cat ~/Documents/security_codes/github_token.txt`
GIT_USERNAME="PROgram52bc"

OLD_SEGMENT="https://github.com/$GIT_USERNAME"
NEW_SEGMENT="https://$GIT_TOKEN@github.com/$GIT_USERNAME"

function check_repo {
	old_url=`git remote -vv 2>/dev/null`
	if [ $? -ne 0 ]; then
		echo "Not a git repository."
		return 1
	fi
	
	old_url=`echo $old_url | grep 'origin' | head -n 1 | awk '{print $2}'`
	if [ -z $old_url ]; then
		echo "No remote repository named 'origin'."
		return 1
	fi

	if ! echo $old_url | grep -q "$OLD_SEGMENT"; then
		echo "Remote repository [$old_url] does not match pattern [$OLD_SEGMENT]."
		return 1;
	fi
}

ASK=0

function replace_with_pat {
	echo "old_url: [$old_url]"
	new_url=`echo $old_url | sed "s^$OLD_SEGMENT^$NEW_SEGMENT^"`
	echo "new_url: [$new_url]"

	if [ $ASK = 0 ]; then
		read -n1 -p "Replace? (Y/N/A/Q)" response < /dev/tty
		echo
	else
		response="y"
	fi
	case $response in
		Y|y)
			;;
		A|a)
			ASK=-1
			;;
		Q|q)
			echo "ABORT"
			exit 0
			;;
		N|n|*)
			echo "SKIP"
			return
			;;
	esac
	git remote set-url origin $new_url
}

echo "Using token $GIT_TOKEN"

while IFS= read -r -d $'\0' dir; do
	orig=`pwd`
	dir=${dir%/.git} # remove the trailing .git
	cd $dir
	echo -n "------------ Repo Path: "; pwd
	if check_repo; then
		replace_with_pat
	else
		echo "SKIP"
	fi
	cd "$orig"
done < <(find . -name .git -type d -prune -print0)

# NOTE: not using the -execdir alternative to process all git repository because exporting functions and variables are too complicated and not portable.
# export -f check_repo
# find . -name .git -type d -prune -execdir /bin/bash -c 'check_repo' ';'
