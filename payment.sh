script=$(realpath "$0")
script_path=$(dirname "$script")
source=$(script_path)/common.sh

echo -e "\e[34m>>>>>>> Install Python <<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[34m>>>>>>> Add Application user  <<<<<<<\e[0m"
useradd ${user_app}

echo -e "\e[34m>>>>>>> Create App Direactory <<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>> Download the application content <<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[34m>>>>>>> Extract the application Content <<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[34m>>>>>>> Install Python Dependencies <<<<<<<\e[0m"
cd /app
pip3.6 install -r requirements.txt

echo -e "\e[34m>>>>>>> Setup SystemD Payment service <<<<<<<\e[0m"
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[34m>>>>>>> load and restart the service <<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment