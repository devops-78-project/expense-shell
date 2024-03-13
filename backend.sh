root_user_password=$1

source common.sh

mysql_root_password=$1

if  [ -z "${mysql_root_password}" ]; then
  echo input password is missing
  exit 1

fi


print_heading_task "disable default old nodejs version"
dnf module disable nodejs -y &>>/tmp/expense.log
echo $?

print_heading_task "enable new nodejs version"
dnf module enable nodejs:20 -y &>>/tmp/expense.log
echo $?


print_heading_task "install nodejs"
dnf install nodejs -y &>>/tmp/expense.log
echo $?

print_heading_task "add user application"
useradd expense &>>/tmp/expense.log
echo $?

print_heading_task "copy backendservice conf file"
cp backendservice.conf /etc/systemd/system/backend.service &>>/tmp/expense.log
echo $?

print_heading_task "clean the old content"
rm -rf /app &>>/tmp/expense.log
echo $?

print_heading_task "create app directory"
mkdir /app &>>/tmp/expense.log
echo $?

print_heading_task "download app content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
echo $?

print_heading_task "extract app content"
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
echo $?

print_heading_task "download nodejs dependencies"
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
echo $?

print_heading_task "run daemon-reload"
systemctl daemon-reload &>>/tmp/expense.log
echo $?

print_heading_task "start backend service"
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
echo $?

print_heading_task "install mysql"
dnf install mysql -y &>>/tmp/expense.log
echo $?

print_heading_task "load schema"
mysql -h 172.31.92.59 -uroot -p${root_user_password} < /app/schema/backend.sql &>>/tmp/expense.log
echo $?