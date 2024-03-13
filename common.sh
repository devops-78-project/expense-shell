log=/tmp/expense.log

print_heading_task(){
  echo $1
  echo  "##### $1 #######" &>>$log

}

check_status(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m success  \e[0m"
    else
      echo -e "\e[31m failure  \e[0m"
      exit 2

  fi

}

App_Prereq() {
  print_heading_task "clean the old content"
  rm -rf ${app_dir} &>>$log
  check_status $?


  print_heading_task "create app directory"
  mkdir ${app_dir} &>>$log
  check_status $?


  print_heading_task "download app content"
  curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/expense-${component}-v2.zip &>>$log
  check_status $?


  print_heading_task "extract app content"
  cd ${app_dir} &>>$log
  unzip /tmp/${component}.zip &>>$log
  check_status $?
}