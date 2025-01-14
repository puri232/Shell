#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SDIR=$1
DDIR=$2
DAYS=${3:-14}

FOLDER_NAME="/home/ec2-user/shellscript.logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FILE_NAME="$FOLDER_NAME/$LOG_FILE-$TIMESTAMP.log"

USAGE(){
    echo -e "$R USAGE:: $N backup <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
    exit 1
}

mkdir -p /home/ec2-user/shellscript.logs
echo "script started executing at : $TIMESTAMP" &>>$LOGS_FILE_NAME