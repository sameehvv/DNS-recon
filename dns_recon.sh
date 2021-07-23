#!/bin/bash

red="\e[91m"
none="\e[0m"

zonetransfer()
{
	dig ns $1 +short > ns.txt
	while read ns;do
		dig axfr @$ns $1 | if grep -iq "Transfer failed"; then echo "Zone transfer Failed";else echo -e "${red}Zone Transfer success in '$ns'${none}";fi
	done < ns.txt
	rm ns.txt
}

if [ "$1" == "" ] 
then
	echo "Usage :- $0 domain" 
else
	echo "$1 Records -"
	echo "====================="
	for i in A AAAA ns MX CNAME TXT;do
		echo "[+]$i record -"
		dig $i $1 +short
		if [[ $i == "ns" ]]; then
			zonetransfer $1
		fi
		echo -e "\n"
	done
fi
