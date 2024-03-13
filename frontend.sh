source common.sh

print_heading_task "install nginx"
dnf install nginx -y
check status $?

print_heading_task "enable nginx"
systemctl enable nginx
systemctl start nginx
check status $?

print_heading_task "copy expenseservice.conf"
cp expenseservice.conf /etc/nginx/default.d/expense.conf
check status $?

print_heading_task "clean old content"
rm -rf /usr/share/nginx/html/*
check status $?

print_heading_task "install app content"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip
check status $?

print_heading_task "extract app content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
check status $?

print_heading_task "restart nginx"
systemctl restart nginx
check status $?