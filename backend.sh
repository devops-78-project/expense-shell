root_user_password=$1

source common.sh

mysql_root_password=$1
app_dir=/app
component=backend

if  [ -z "${mysql_root_password}" ]; then
  echo input password is missing
  exit 1

fi


print_heading_task "disable default old nodejs version"
dnf module disable nodejs -y &>>$log
check_status $?

print_heading_task "enable new nodejs version"
dnf module enable nodejs:20 -y &>>$log
check_status $?


print_heading_task "install nodejs"
dnf install nodejs -y &>>$log
check_status $?

print_heading_task "add user application"
if [ $1 -ne 0 ]; then
    useradd expense &>>$log
fi
check_status $?


print_heading_task "copy backendservice conf file"
cp backendservice.conf /etc/systemd/system/backend.service &>>$log
check_status $?


App_Prereq


print_heading_task "download nodejs dependencies"
cd /app &>>$log
npm install &>>$log
check_status $?


print_heading_task "run daemon-reload"
systemctl daemon-reload &>>$log
check_status $?


print_heading_task "start backend service"
systemctl enable backend &>>$log
systemctl start backend &>>$log
check_status $?


print_heading_task "install mysql"
dnf install mysql -y &>>$log
check_status $?


print_heading_task "load schema"
 echo 'show databases' | mysql -h 172.31.92.59 -uroot -p${root_user_password} &>>$log
if [ $? -ne 0 ]; then
   mysql -h mysql-dev.ganeshreddy12.online -uroot -p${root_user_password} < /app/schema/backend.sql &>>$log
fi
check_status $?

