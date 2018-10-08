#!/bin/bash
# Usage: diffs dir1 dir2

# 1:check params
if [ $# -ne 2 ]
then
        echo Usage:./diffs.sh directory1 directory2
        exit 2
fi

dir1=$1
dir2=$2

# 2:check if is dir
if [ ! -d $dir1 ]
then
	echo $dir1 is not directory!
	exit 2
fi
if [ ! -d $dir2 ]
then
        echo $dir1 is not directory!
        exit 2
fi

# funciton: if dir contain a file
function contains {
	f=$1
	shift
	dirs=(`echo "$@"`)
	find=0
	for cmp in `echo ${dirs[@]}`
	do
		if [[ $cmp == $f ]]
		then
			find=1
			break
		fi
	done
	if [ $find -eq 0 ]
	then 
		echo 0
	else
		echo 1
	fi
}

# 3:here we simply use ls to list both files under,no recursion
dir1_files=`ls -l $dir1| grep "^-"| gawk '{print $NF}'`
dir2_files=`ls -l $dir2| grep "^-"| gawk '{print $NF}'`

# TODO: list files that only exist in one of dirs
# 4:find files both dirs have
diff_files=( )
for f in ${dir1_files[@]}
do
	c=`contains $f $dir2_files`
	if [[ $c == "1" ]]
	then
		idx=${#diff_files[@]}
		diff_files[ $idx ]=$f
	fi
done

# 5:do diff file
for f in ${diff_files[@]}
do
	echo diff $dir1/$f $dir2/$f ...
	diff $dir1/$f $dir2/$f
done
