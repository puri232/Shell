#!/bin/bash

USRID=$( id -u)

if [ $USERID -ne 0 ]
then 
    echo "ERROR:: You must  have sudo access to execute this script"
    exit 1 #other than 1
fi

dnf list installed mysql

if [ $? -ne 0 ] #not installed
then 
    dnf install mysql -y
    if [ $? -ne 0]
    then
        echo "Installing MySQL ... FAILURE"
        exit 1
    else
        echo " Installing MYSQL ... SUCESSS"
    fi  
else
    echo " MysQL is already ... Installed"
fi

dnf list installed git

if [ $? -ne 0] #not installed
then 
    dnf install git -y
    if [ $? -ne 0]
    then
        echo "Installing git ... FAILURE"
        exit 1
    else
        echo " Installing git ... SUCESSS"
    fi  
else
    echo " Git is already ... Installed"
fi