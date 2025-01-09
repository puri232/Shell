#!/bin/bash
#!/bin/bash

USRID=$( id -u)
VALIDATE () {
    if [$1 -ne 0]
    then
        echo "$2 ... FAILURE"
        exit 1
    else
        echo " $2 ... SUCESSS"
    fi 
 }

if [$USERID -ne 0]
then 
    echo "ERROR:: You must  have sudo access to execute this script"
    exit 1 #other than 1
fi

dnf list installed mysql

    if [ $? -ne 0 ] #not installed
    then 
        dnf install mysql -y
        VALIDATE #? "Installing MYSQL"
    else
        echo " MysQL is already ... Installed"
    fi

dnf list installed git
    if [$? -ne 0] #not installed
    then 
        dnf install git -y
        VALIDATE #? "Installing Git"
    else
        echo " Git is already ... Installed"
    fi