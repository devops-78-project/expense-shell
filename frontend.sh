source common.sh

app_dir=/usr/share/nginx/html
component = frontend



print_heading_task "install nginx"
dnf install nginx -y &>>$log
check_status $?

print_heading_task "enable nginx"
systemctl enable nginx &>>$log
systemctl start nginx &>>$log
check_status $?


print_heading_task "copy expenseservice.conf"
cp expenseservice.conf /etc/nginx/default.d/expense.conf &>>$log
check_status $?


App_Prereq


print_heading_task "restart nginx"
systemctl restart nginx &>>$log
check_status $?
