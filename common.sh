app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname "$script")

print_head()
{
 echo -e "\e[34m>>>>>>> $1 >>>>>>>\e[0m"
}
func_nodejs()
{

print_head "Configure NodeJS repos"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Install NodeJS"
yum install nodejs -y

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

print_head "Install Dependencies"
npm install

print_head "Setup SystemD Service"

cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "Start cart Service"
systemctl daemon-reload

print_head  "Restart Service"
systemctl enable ${component}
systemctl restart ${component}

}

schema_setup()
{
echo -e "\e[34m>>>>>>> copy mongo repo    >>>>>>>\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>> Install mongo client   >>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[34m>>>>>>> Load Mongo Schema   >>>>>>>\e[0m"
mongo --host mongo.devopspractice.tech </app/schema/catalogue.js
}