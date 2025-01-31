#!/bin/bash

USRID=$( id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"

VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCESSS $N"
    fi 
 }

if [ $USRID -ne 0 ]
    then 
        echo "ERROR:: You must  have sudo access to execute this script"
        exit 1 #other than 1
    fi

dnf list installed mysql
if [ $? -ne 0 ] 
then #not installed
    dnf install mysql -y
    VALIDATE #? "Installing MYSQL"
else
    echo -e "MysQL is already ... $Y Installed $N"
fi    

dnf list installed git
if [ $? -ne 0 ] #not installed
then 
    dnf install git -y
    VALIDATE #? "Installing Git"
else
    echo -e "Git is already ... $Y Installed $N"
fi