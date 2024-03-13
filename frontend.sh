source common.sh



print_heading_task "install nginx"
dnf install nginx -y &>>$log
check status $? &>>$log

print_heading_task "enable nginx"
systemctl enable nginx &>>$log
systemctl start nginx &>>$log
check status $? &>>$log

print_heading_task "copy expenseservice.conf"
cp expenseservice.conf /etc/nginx/default.d/expense.conf &>>$log
check status $? &>>$log

print_heading_task "clean old content"
rm -rf /usr/share/nginx/html/* &>>$log
check status $? &>>$log

print_heading_task "install app content"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log
check status $? &>>$log

print_heading_task "extract app content"
cd /usr/share/nginx/html &>>$log
unzip /tmp/frontend.zip &>>$log
check status $? &>>$log

print_heading_task "restart nginx"
systemctl restart nginx &>>$log
check status $? &>>$log