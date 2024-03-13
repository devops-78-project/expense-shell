print_heading_task(){
  echo $1
  echo  "##### $1 #######" &>>/tmp/expense.log

}

check_status(){
  if [ $1 -eq 0 ]; then
    echo success
    else
      echo failure

  fi

}