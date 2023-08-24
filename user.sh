script=$(realpath "$0")
script_path=$(dirname "$script")
source=$(script_path)/common.sh

echo -e "\e[34m>>>>>>> Configure NodeJS repos >>>>>>>\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[34m>>>>>>> Install NodeJS >>>>>>>\e[0m"
yum install nodejs -y

echo -e "\e[34m>>>>>>> Add Application User  >>>>>>>\e[0m"
useradd ${app_user}

echo -e "\e[34m>>>>>>> Create App Directory >>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>> Download the Application content >>>>>>>\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

echo -e "\e[34m>>>>>>> Unzip the app content >>>>>>>\e[0m"
cd /app
unzip /tmp/user.zip

echo -e "\e[34m>>>>>>> Install Dependencies  >>>>>>>\e[0m"
npm install

echo -e "\e[34m>>>>>>> Setup SystemD Service   >>>>>>>\e[0m"
cp ${script_path}/user.service /etc/systemd/system/user.service

echo -e "\e[34m>>>>>>> Start User Service >>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user


echo -e "\e[34m>>>>>>> copy mongo repo    >>>>>>>\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>> Install mongo client   >>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[34m>>>>>>> Load Mongo Schema   >>>>>>>\e[0m"
mongo --host mongo.devopspractice.tech </app/schema/user.js