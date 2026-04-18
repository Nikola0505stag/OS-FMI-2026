#!/bin/bash

TEMP_FILE=$(mktemp)
FILE_NAME=$(mktemp)

echo 'java' >> $TEMP_FILE

FOUND_JAR="False"

for arg in "$@"; do

	if [ $FOUND_JAR = "True" ]; then
		
		if [ $arg = "-jar" ]; then
			echo "Can't have two -jar!"
			exit 1
		fi


		if echo $arg | grep -qE -- "-D"; then
			echo $arg >> $TEMP_FILE
		elif [ $(cat $FILE_NAME | wc -l) -eq 2 ]; then
			echo $arg >> $TEMP_FILE
		else 
			echo $arg >> $FILE_NAME
		fi

	else 
		
		if echo $arg | grep -qE -- "-jar"; then
			FOUND_JAR="True"
			echo $arg >> $FILE_NAME
		else 
			echo $arg >> $TEMP_FILE
		fi

	fi
		
done

BEFORE_JAR=$(mktemp)
AFTER_JAR=$(mktemp)

while read -r line; do
	
	if echo $line | grep -qE "-"; then
		echo $line >> $BEFORE_JAR
	elif [ $line = "java" ]; then
		echo $line >> $BEFORE_JAR
	else 
		echo $line >> $AFTER_JAR
	fi

done < $TEMP_FILE

FINAL_FILE=$(mktemp)


while read -r line; do
	echo $line >> $FINAL_FILE
done < $BEFORE_JAR

while read -r line; do
	echo $line >> $FINAL_FILE
done < $FILE_NAME

while read -r line; do
	echo $line >> $FINAL_FILE
done < $AFTER_JAR

cat $FINAL_FILE | tr '\n' ' '

rm $FILE_NAME
rm $TEMP_FILE
rm $BEFORE_JAR
rm $AFTER_JAR
rm $FINAL_FILE
