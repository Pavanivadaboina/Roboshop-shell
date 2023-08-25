app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname "$script")

print_head()
{
 echo -e "\e[34m>>>>>>> $1 >>>>>>>\e[0m"
}

if [ "schema_setup" == "mongo" ]; then
echo print_head "copy mongo repo"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo print_head "Install mongo client"
yum install mongodb-org-shell -y

echo "print_head Load Mongo Schema"
mongo --host mongo.devopspractice.tech </app/schema/catalogue.js
fi
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

schema_setup
}