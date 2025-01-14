#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SDIR=$1
DDIR=$2
DAYS=${ 3:-14 }


FOLDER_NAME="/home/ec2-user/shellscript.logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FILE_NAME="$FOLDER_NAME/$LOG_FILE-$TIMESTAMP.log"

VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCESSS $N" 
    fi 
 }
USAGE(){
    echo -e "$R USAGE  :: $N sh 18-backup.sh <sourdir> <dst Dir> <Days (optional)>"
    exit 1
}

if [$# -lt 2]
then

fi

echo "script started executing at : $TIMESTAMP" &>>$LOGS_FILE_NAME