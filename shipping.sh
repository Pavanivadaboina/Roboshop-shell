script=$(realpath "$0")
script_path=$(dirname "$script")
source $(script_path)/common.sh

mysql_root_password=$1

echo -e "\e[34m>>>>>>> Install Java Dependency MAVEN >>>>>>>\e[0m"
yum install maven -y

echo -e "\e[34m>>>>>>> create application user >>>>>>>\e[0m"
useradd ${user_app}

echo -e "\e[34m>>>>>>> create application direactory >>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m>>>>>>> Download the application content >>>>>>>\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[34m>>>>>>> extract app content >>>>>>>\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[34m>>>>>>> Download maven Dependencies  >>>>>>>\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[34m>>>>>>> Start SystemD Shipping Service >>>>>>>\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

echo -e "\e[34m>>>>>>> Install Mysql Client >>>>>>>\e[0m"
yum install mysql -y

echo -e "\e[34m>>>>>>> Load Schema >>>>>>>\e[0m"
mysql -h mysql.devopspractice.tech -uroot -${mysql_root_password} < /app/schema/shipping.sql
systemctl restart shipping