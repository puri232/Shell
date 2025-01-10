#!/bin/bash

USRID=$( id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SDIR="/app"

FOLDER_NAME="/var/log/shelljaffa.log"
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

CHECK_ROOT() {
if [ $USRID -ne 0 ]
    then 
        echo "ERROR:: You must  have sudo access to execute this script"
        exit 1 #other than 1
    fi
}

mkdir -p $FOLDER_NAME
echo "script started executing at : $TIMESTAMP" &>>$LOGS_FILE_NAME

FILES_DELETED=$(find $SDIR -name "*.my" -mtime +14)
echo " files to be deleted $FILES_DELETED