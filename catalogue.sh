source common.sh
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
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[34m>>>>>>> Unzip the app content >>>>>>>\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[34m>>>>>>> Install Dependencies  >>>>>>>\e[0m"
npm install

echo -e "\e[34m>>>>>>> Setup SystemD Service   >>>>>>>\e[0m"
cp /home/centos/Roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[34m>>>>>>> Start Catalogue Service >>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[34m>>>>>>> copy mongo repo    >>>>>>>\e[0m"
cp /home/centos/Roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>> Install mongo client   >>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[34m>>>>>>> Load Mongo Schema   >>>>>>>\e[0m"
mongo --host mongo.devopspractice.tech </app/schema/catalogue.js
