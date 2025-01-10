#!/bin/bash

USRID=$( id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
FOLDER_NAME="/var/log/expense.log"
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

CHECK_ROOT

dnf install nginx -y  &>>$LOGS_FILE_NAME
VALIDATE $? "install nginx"

systemctl enable nginx &>>$LOGS_FILE_NAME
VALIDATE $? "enable nginx"

systemctl restart nginx  &>>$LOGS_FILE_NAME
VALIDATE $? "restarting nginx"

rm -rf /usr/share/nginx/html/*  &>>$LOGS_FILE_NAME
VALIDATE $? "remove the default page"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGS_FILE_NAME
VALIDATE $? "curl the new html page"

cd /usr/share/nginx/html &>>$LOGS_FILE_NAME
VALIDATE $? "goto the html folder"


unzip /tmp/frontend.zip  &>>$LOGS_FILE_NAME
VALIDATE $? "unzip the folder"

cp /home/ec2-user/Shell/expense.conf /etc/nginx/default.d/expense.conf  &>>$LOGS_FILE_NAME
VALIDATE $? "created expense.conf"

systemctl restart nginx  &>>$LOGS_FILE_NAME
VALIDATE $? "restart nginx"