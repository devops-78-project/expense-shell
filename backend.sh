root_user_password=$1

source common.sh

mysql_root_password=$1

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
useradd expense &>>$log
check_status $?


print_heading_task "copy backendservice conf file"
cp backendservice.conf /etc/systemd/system/backend.service &>>$log
check_status $?


print_heading_task "clean the old content"
rm -rf /app &>>$log
check_status $?


print_heading_task "create app directory"
mkdir /app &>>$log
check_status $?


print_heading_task "download app content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>$log
check_status $?


print_heading_task "extract app content"
cd /app &>>$log
unzip /tmp/backend.zip &>>$log
check_status $?


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
mysql -h 172.31.92.59 -uroot -p${root_user_password} < /app/schema/backend.sql &>>$log
check_status $?
