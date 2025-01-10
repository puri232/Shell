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
        echo -e "$2 ... $R FAILURE $N" &>>$LOGS_FILE_NAME
        exit 1
    else
        echo -e "$2 ... $G SUCESSS $N" &>>$LOGS_FILE_NAME
    fi 
 }

sudo mkdir -p $FOLDER_NAME


CHECK_ROOT() {
if [ $USRID -ne 0 ]
    then 
        echo "ERROR:: You must  have sudo access to execute this script"
        exit 1 #other than 1
    fi
}

echo "script started executing at : $TIMESTAMP" &>>$LOGS_FILE_NAME

CHECK_ROOT
dnf install mysql-server -y &>>$LOGS_FILE_NAME
VALIDATE $? "installing Mysql Server"

systemctl enable mysqld &>>$LOGS_FILE_NAME
VALIDATE $? "Enableing mysql server"

systemctl start mysqld &>>$LOGS_FILE_NAME
VALIDATE $? "starting mysql server"

mysql -h mysql.purnachandra.space -u root -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    echo "Mysql root password is not setup" &>>$LOGS_FILE_NAME
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGS_FILE_NAME
    VALIDATE $? "Setting root pasword"
else
    echo -e "mysql root password already setup...$Y SKIPPING $N"
fi