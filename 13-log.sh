#!/bin/bash

USRID=$( id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
FOLDER_NAME="/var/log/shellscript.log"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGS_FILE_NAME="$FOLDER_NAME/$LOG_FILE-$TIMESTAMP.log"

VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N" &>>$LOGS_FILE_NAME
        exit 1
    else
        echo -e "$2 ... $G SUCESSS $N" &>>$LOGS_FILE_NAME
    fi 
 }

echo "script started executing at : $TIMESTAMP" &>>$LOGS_FILE_NAME

if [ $USRID -ne 0 ]
    then 
        echo "ERROR:: You must  have sudo access to execute this script"
        exit 1 #other than 1
    fi

dnf list installed mysql &>>$LOGS_FILE_NAME
if [ $? -ne 0 ] 
then #not installed
    dnf install mysql -y
    VALIDATE #? "Installing MYSQL"
else
    echo -e "MysQL is already ... $Y Installed $N" &>>$LOGS_FILE_NAME
fi    

dnf list installed git &>>$LOGS_FILE_NAME
if [ $? -ne 0 ] #not installed
then 
    dnf install git -y &>>$LOGS_FILE_NAME
    VALIDATE #? "Installing Git"
else
    echo -e "Git is already ... $Y Installed $N" &>>$LOGS_FILE_NAME
fi