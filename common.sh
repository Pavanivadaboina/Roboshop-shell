app_user=roboshop

log_file=/tmp/Roboshop-shell.log

print_head()
{
 echo -e "\e[34m>>>>>>> $1 <<<<<<<\e[0m"
}

func_status_check()
{
  if [ $1 -eq 0 ];
 then
  echo -e "\e[32mSUCCESS\e[0m"
 else
   echo -e "\e[31mFAILURE\e[0m"
 exit 1
fi
}


schema_setup()
{
if [ "$schema_setup" == "mongo" ]; then

  print_head "copying mongo repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
func_status_check $?
  print_head "Install mongo client"
  yum install mongodb-org-shell -y &>>$log_file
func_status_check $?

  print_head "Load Mongo Schema"
  mongo --host mongo.devopspractice.tech </app/schema/${component}.js &>>$log_file
func_status_check $?

  systemctl restart ${component} &>>$log_file
func_status_check $?
fi


if [ "$schema_setup" == "mysql" ]; then
print_head "copying mysql repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_status_check $?

  print_head "Install Mysql Client"
  yum install mysql -y &>>$log_file
func_status_check $?

  print_head "Load Schema"
  mysql -h mysql.devopspractice.tech -uroot -p${mysql_root_passwd} < /app/schema/${component}.sql &>>$log_file
func_status_check $?

fi
}

func_systemd()
{
  print_head "Start SystemD Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  systemctl daemon-reload
  print_head "system restart"
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
func_status_check $?
}

func_app_prereq()
{
  print_head "create Application User"
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
  useradd ${app_user} &>>$log_file
  fi
  func_status_check $?

  print_head "Create App Directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_status_check $?

  print_head "Download the Application content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_status_check $?

  print_head "Unzip the app content"
  cd /app &>>$log_file
  unzip /tmp/${component}.zip &>>$log_file
  func_status_check $?

}


func_nodejs()
{

print_head "Configure NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
func_status_check $?

print_head "Install NodeJS"
yum install nodejs -y &>>$log_file
func_status_check $?

func_app_prereq

print_head "Install Dependencies"
npm install &>>$log_file
func_status_check $?

schema_setup
func_systemd

}

func_java()
{
  print_head "Install Java Dependency MAVEN"
  yum install maven -y &>>$log_file
  func_status_check $?

  func_app_prereq

  print_head "Download maven Dependencies"
  mvn clean package &>>$log_file
  func_status_check $?

  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_status_check $?

  schema_setup

  func_systemd

}

func_python()
{
print_head "Install Python"
yum install python36 gcc python3-devel -y &>>$log_file
func_status_check $?

func_app_prereq

print_head "Install Python Dependencies"
pip3.6 install -r requirements.txt &>>$log_file
func_status_check $?

print_head  "Update passwords in SystemD Payment service"
sed -i -e "s|rabbitmq_user_password|${rabbitmq_user_password}|" ${script_path}/${component}.service &>>$log_file
func_status_check $?

func_systemd

}