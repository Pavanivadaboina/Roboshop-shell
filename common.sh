app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname "$script")

print_head()
{
 echo -e "\e[34m>>>>>>> $1 >>>>>>>\e[0m"
}

func_status_check()
{
  if [ $? -eq 0 ];
 then
  echo -e "\e[32mSUCCESS\e[0m"
 else
   echo -e "\e[31SUCCESS\e[0m"



schema_setup() {
if [ "$schema_setup" == "mongo" ]; then
  print_head "copy mongo repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  print_head "Install mongo client"
  yum install mongodb-org-shell -y

  print_head "Load Mongo Schema"
  mongo --host mongo.devopspractice.tech </app/schema/${component}.js
fi

if [ "$schema_setup" == "mysql" ]; then

  print_head "Install Mysql Client"
  yum install mysql -y

  print_head "Load Schema"
  mysql -h mysql.devopspractice.tech -uroot -or${mysql_root_passwd} < /app/schema/${component}.sql
  systemctl restart ${component}
fi
}
func_systemd()
{
  print_head "Start SystemD Shipping Service"
  cp ${script_path}/shipping.service /etc/systemd/system/${component}.service
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_app_prereq()
{
  print_head Add Application User
  useradd ${user_app}

  print_head "Create App Directory"
  rm -rf /app
  mkdir /app

  print_head "Download the Application content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  print_head "Unzip the app content"
  cd /app
  unzip /tmp/${component}.zip
}


func_nodejs()
{

print_head "Configure NodeJS repos"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Install NodeJS"
yum install nodejs -y

func_app_prereq

print_head "Install Dependencies"
npm install

schema_setup

func_systemd

}

func_java()
{
  print_head "Install Java Dependency MAVEN"
  yum install maven -y

func_app_prereq

  print_head "Download maven Dependencies"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  schema_setup

  func_systemd

