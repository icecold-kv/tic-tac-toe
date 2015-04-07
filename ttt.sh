#!/bin/bash

function draw_field {
	for i in 0 3 6
	do
		for j in 0 1 2
		do 
			if [ $j -ne '2' ]
			then
				if [ ${arr[i+j]} != 'e' ]
				then
					echo -n "${arr[i+j]}|"
				else
					echo -n " |"
				fi
			elif [ ${arr[i+j]} != 'e' ]
				then
					echo "${arr[i+j]}"
				else
					echo " "
			fi
		done
		if [ $i -ne '6' ]
		then
			echo "-+-+-"
		fi
	done
}

if [ -a 'X' ]
then
	rm X
	me='O'
	opp='X'
	my_turn=false
	echo "Waiting for connection..."
	echo 'r' > fifo
else
	mknod X p
	me='X'
	opp='O'
	my_turn=true
	mknod fifo p 2>/dev/null
	echo "Waiting for connection..."
	mes=$(cat fifo)
fi

arr=(e e e e e e e e e)
cnt=0

while [ true ]
do
	if [ $my_turn = true ]
	then
		clear
		draw_field
		if [ "${arr[0]}" = "${arr[1]}" -a "${arr[1]}" = "${arr[2]}" -a "${arr[0]}" != 'e' -o "${arr[3]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[5]}" -a "${arr[3]}" != 'e' -o "${arr[6]}" = "${arr[7]}" -a "${arr[7]}" = "${arr[8]}" -a "${arr[6]}" != 'e' -o "${arr[0]}" = "${arr[3]}" -a "${arr[3]}" = "${arr[6]}" -a "${arr[0]}" != 'e' -o "${arr[1]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[7]}" -a "${arr[1]}" != 'e' -o "${arr[2]}" = "${arr[5]}" -a "${arr[5]}" = "${arr[8]}" -a "${arr[2]}" != 'e' -o "${arr[0]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[8]}" -a "${arr[0]}" != 'e' -o "${arr[2]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[6]}" -a "${arr[2]}" != 'e' ]
		then
			echo "You lose"			
			break
		fi
		if [ $cnt -eq 9 ]
		then
			echo "Draw game"
			break
		fi
		echo "Your turn"
		echo -n "Line:   "
		read i
		echo -n "Column: "
		read j
		if [ [$i -gt 3] -o [$j -gt 3] ]
		then
			continue
		fi
		let "i = 3*(i-1)+j-1"
		if [ ${arr[$i]} = 'e' ]
		then		
			echo "$i" > fifo
			arr[$i]=$me
			let "cnt = cnt + 1"
		else
			continue
		fi
		my_turn=false
	else
		clear
		draw_field
		if [ "${arr[0]}" = "${arr[1]}" -a "${arr[1]}" = "${arr[2]}" -a "${arr[0]}" != 'e' -o "${arr[3]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[5]}" -a "${arr[3]}" != 'e' -o "${arr[6]}" = "${arr[7]}" -a "${arr[7]}" = "${arr[8]}" -a "${arr[6]}" != 'e' -o "${arr[0]}" = "${arr[3]}" -a "${arr[3]}" = "${arr[6]}" -a "${arr[0]}" != 'e' -o "${arr[1]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[7]}" -a "${arr[1]}" != 'e' -o "${arr[2]}" = "${arr[5]}" -a "${arr[5]}" = "${arr[8]}" -a "${arr[2]}" != 'e' -o "${arr[0]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[8]}" -a "${arr[0]}" != 'e' -o "${arr[2]}" = "${arr[4]}" -a "${arr[4]}" = "${arr[6]}" -a "${arr[2]}" != 'e' ]
		then
			echo "You won"
			rm fifo
			break
		fi
		if [ $cnt -eq 9 ]
		then
			echo "Draw game"
			rm fifo
			break
		fi
		echo "Wait for opponent"
		c=$(cat fifo)
		arr[$c]=$opp
		let "cnt = cnt + 1"
		c=''
		my_turn=true
	fi
done

exit
