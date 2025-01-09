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

echo "script started executing at : $TIMESTAMP" &>>$LOGS_FILE_NAME

CHECK_ROOT

dnf module disable nodejs -y  &>>$LOGS_FILE_NAME
VALIDATE $? "Disanling existing default nodejs"

dnf module enable nodejs:20 -y  &>>$LOGS_FILE_NAME
VALIDATE $? "enablingg existing default nodejs"

dnf install nodejs -y  &>>$LOGS_FILE_NAME
VALIDATE $? "install NodeJs"

id expense 
if [$? -ne 0]
then
useradd expense  &>>$LOGS_FILE_NAME
VALIDATE $? "Adding Expense user"
else
    echo -e "expense user already exist.. $Y SKIPPING $N"
fi

mkdir /app  &>>$LOGS_FILE_NAME
VALIDATE $? "Directory app creation"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "curl"

cd /app
VALIDATE $? " app open for npm"


unzip /tmp/backend.zip  &>>$LOGS_FILE_NAME
VALIDATE $? "unzip file"

cd /app
VALIDATE $? "app open"

npm install  &>>$LOGS_FILE_NAME
VALIDATE $? "install dependencies"

cp /home/ec2-user/Shell/backend.service /etc/systemd/system/backend.service  &>>$LOGS_FILE_NAME
VALIDATE $? "copy backend.service"

systemctl daemon-reload
VALIDATE $? "relaod deamon"

systemctl start backend
VALIDATE $? "start backend"

systemctl enable backend
VALIDATE $? "enable backend"

dnf install mysql -y  &>>$LOGS_FILE_NAME
VALIDATE $? "install mysql"

mysql -h mysql.purnachandra.space -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "input backend.sql app scheme"

systemctl restart backend
VALIDATE $? "restart backend"