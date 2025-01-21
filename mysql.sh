#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%s)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
  if [ $1 -ne 0]
  then
    echo -e "$2 ..... $R FAILURE $N"
    exit 1
  else
    echo -e  "$2 ..... $G SUCCESS $N"
  fi
}

if [$USERID -ne 0]
then
  echo "Please run the script with the super user"
  exit 1
else
  echo "You are a root user"
fi

dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "Installing MySql Server"

systemctl enable mysqld &>>LOGFILE
VALIDATE $? "Enabling MySql Server"

systemctl start mysqld &>>LOGFILE
VALIDATE $? "Starting MySql Server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting up root password"
