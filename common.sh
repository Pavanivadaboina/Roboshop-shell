app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname "$script")


func_nodejs()
{

echo -e "\e[34m>>>>>>> Configure NodeJS repos >>>>>>>\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[34m>>>>>>> Install NodeJS >>>>>>>\e[0m"
yum install nodejs -y

echo -e "\e[34m>>>>>>> Add Application User  >>>>>>>\e[0m"
useradd ${user_app}

echo -e "\e[34m>>>>>>> Create App Directory >>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>> Download the Application content >>>>>>>\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

echo -e "\e[34m>>>>>>> Unzip the app content >>>>>>>\e[0m"
cd /app
unzip /tmp/${component}.zip

echo -e "\e[34m>>>>>>> Install Dependencies  >>>>>>>\e[0m"
npm install

echo -e "\e[34m>>>>>>> Setup SystemD Service   >>>>>>>\e[0m"

cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

echo -e "\e[34m>>>>>>> Start cart Service >>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[34m>>>>>>> Restart cart Service >>>>>>>\e[0m"
systemctl enable ${component}
systemctl restart ${component}}

}