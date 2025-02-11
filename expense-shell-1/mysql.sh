#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB Password"
read -s mysql_root_password

dnf install mysql-server -y &>>LOGFILE

systemctl enable mysqld &>>LOGFILE
#VALIDATE $? "Enabling MySql Server"

systemctl start mysqld &>>LOGFILE
#VALIDATE $? "Starting MySql Server"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.devops91.in -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
  #VALIDATE $? "MySQL Root password setup"
else
  echo -e  "MySql Root password is already setup .... $Y SKIPPING $N "
fi