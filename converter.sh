#!/bin/bash

#set default variable
base="EUR"
target="USD"
dates="$(curl -s "https://api.exchangeratesapi.io/latest" | jq ".date" | sed 's/"//g')"

usage() { echo "Usage: $0 [ -h ]";echo "Usage: $0 [ -f currency ]* [ -t currency ]* [ -d date ]* [ number ]";}

#check what options are given
while getopts ":hf:t:d:" opt
do
	case $opt in
	#show the usage and stop
	h)
		usage
		exit 1
		;;
	#determine which currency should be base
	f)
		base="$OPTARG"
		#get the strings of all the currencys in European Central Bank
		keys="$(curl -s "https://api.exchangeratesapi.io/latest" | jq -e ".rates" | jq -e "keys")"
		#if find such currency string, put it in "buff" as variable
		buff="$(echo $keys | grep "\"$base\"")"
		#if failed to get such currency, "buff" will be empty
		if [[ $buff == "" && $base != "EUR" ]]
		then
			echo "The base currency type should be -f [ currency ]"
			exit 1
		fi
		;;
	#determine which currency should be output
	t)
		target="$OPTARG"
		keys="$(curl -s "https://api.exchangeratesapi.io/latest" | jq -e ".rates" | jq -e "keys")"
		buff="$(echo $keys | grep "\"$target\"")"
		if [[ $buff == "" && $target != "PLN" ]]
		then
			echo "The target currency type should be -t [ currency ]"
			exit 1
		fi
		;;
	#determine which date's data you want to get
	d)
		dates="$OPTARG"
		#date's format should be [ YYYY-MM-DD ] and check whether it is a real date (2018-03-10 is a real date but 2018-06-31 or 2018-15-20 are not)
		if [[ $dates =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$dates" >/dev/null 2>&1
		then
			true
		else
			echo "The date type should be -d [ YYYY-MM-DD ]"
			exit 1
		fi
		;;
	#if use argument different from above, show this error
	\?)
		VAR_D="$OPTARG"
		echo "Invalid option: -$VAR_D"
		exit 1
		;;

	#if any argument needs following argument but don't get it, show this error
	:)
		echo "Option -$OPTARG requires an argument."
		exit 1
		;;

	esac
done

#check that the last command line argument is integer or decimal number(19, 0, 0.36, 0.00, 5.7890 is valid but 05, 087.54, 0. is invalid)
if [[ ${*: -1:1} =~ ^[1-9][0-9]*(\.[0-9]+)?$|^[0](\.[0-9]+)?$ ]]
then
	money=${*: -1:1}
else
	usage
	exit 0
fi

#check the file which used data are stored exist or not
if [ ! -f /tmp/converter_data.txt ]
then
	#if the file not exist, create one
	rate="$(curl -s "https://api.exchangeratesapi.io/${dates}?base=${base}" | jq ".rates.${target}")"
	echo $dates $base $target "$"$rate  >> /tmp/converter_data.txt
else
	temp="$(cat /tmp/converter_data.txt | grep "$dates $base $target")"
	if [[ $temp != "" ]]
	then
		#if the certain data exists, use it
		rate="$(cat /tmp/converter_data.txt | grep "$dates $base $target" | sed 's/^.*\$//g')"
	else
		#if the certain data does not exist, get and save it to the file
		rate="$(curl -s "https://api.exchangeratesapi.io/${dates}?base=${base}" | jq ".rates.${target}")"
		echo $dates $base $target "$"$rate  >> /tmp/converter_data.txt
	fi
	
fi

result="$(echo $money*$rate | bc)"
echo -e "$money $base = \c"
#the result rounded to two decimal places
printf "%0.2f" $result
echo -e " $target"
