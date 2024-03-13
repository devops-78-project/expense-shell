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

  fi

}