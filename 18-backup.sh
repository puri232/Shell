#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # if user is not providing number of days, we are taking 14 as default

LOGS_FOLDER="/home/ec2-user/shellscript-logs"
LOG_FILE=$(echo $0 | awk -F "/" '{print $NF}' | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

USAGE(){
    #echo -e "$R USAGE:: $N sh 18-backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
    echo -e "$R USAGE:: $N backup <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
    exit 1
}

mkdir -p /home/ec2-user/shellscript-logs

if [ $# -lt 2 ]
then
(USAGE)
fi

if [ ! -d $SOURCE_DIR ]
then
    echo -e "$SOURCE_DIR not exist, please check"\
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    echo -e "$DEST_DIR not exist, please check"
    exit 1
fi

echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

FILES=$( find $SOURCE_DIR -name "*.log" -mtime +$DAYS )

if [ -n "$FILES" ]
then
    echo "files are: $FILES"
    ZIP_FILE="$DEST_DIR/applogs-$TIMESTAMP.Zip"
    find $SOURCE_DIR -name "*.log" -mtime +$DAYS  | zip -@ "$ZIP_FILE"
    if [ -f "$ZIP_FILE" ]
    then
    echo -e " Sucesffully created zip file for files olda than $DAYS"
    while read -r filepath # here filepath is the variable name, you can give any name
        do
            echo "Deleting file: $filepath" &>>$LOG_FILE_NAME
            rm -rf $filepath
            echo "Deleted file: $filepath"
        done <<< $FILES
    else
    echo -e "$R Error:: $N Failed to create ZIP file "
    exit 1
    fi
else
    echo "No files found older than $DAYS"
fi