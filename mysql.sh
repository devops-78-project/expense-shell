source common.sh

mysql_root_password=$1

if  [ -z "${mysql_root_password}" ]; then
  echo input password is missing
  exit 1

fi

print_heading_task "install mysql "
dnf install mysql-server -y &>>$log
check_status $?

print_heading_task "enable mysql service"
systemctl enable mysqld &>>$log
systemctl start mysqld &>>$log
check_status $?

print_heading_task "setup root password"
 echo 'show databases' | mysql -h mysql-dev.ganeshreddy12.online -uroot -p${mysql_root_password}  &>>$log
  if [ $? -ne 0 ]; then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log
 fi
check_status $?
