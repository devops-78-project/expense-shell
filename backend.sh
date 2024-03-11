root_user_password=$1

echo disable default old nodejs version
dnf module disable nodejs -y &>>/tmp/expense.log
echo $?

echo enable new nodejs version
dnf module enable nodejs:20 -y &>>/tmp/expense.log
echo $?

echo install nodejs
dnf install nodejs -y &>>/tmp/expense.log
echo $?

echo add user application
useradd expense &>>/tmp/expense.log
echo $?

echo copy backendservice conf file
cp backendservice.conf /etc/systemd/system/backend.service &>>/tmp/expense.log
echo $?

echo clean the old content
rm -rf /app &>>/tmp/expense.log
echo $?

ech create app directory
mkdir /app &>>/tmp/expense.log
echo $?

echo download app content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
echo $?

echo extract app content
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
echo $?

echo download nodejs dependencies
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
echo $?

echo run daemon-reload
systemctl daemon-reload &>>/tmp/expense.log
echo $?

echo start backend service
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
echo $?

echo install mysql
dnf install mysql -y &>>/tmp/expense.log
echo $?

echo load schema
mysql -h 172.31.92.59 -uroot -p${root_user_password} < /app/schema/backend.sql &>>/tmp/expense.log
echo $?