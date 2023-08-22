echo -e "\e[34m>>>>>>> Disbale modyule sql version 8 >>>>>>>\e[0m"
yum module disable mysql -y

echo -e "\e[34m>>>>>>> Configure Mysql repo >>>>>>>\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[34m>>>>>>> Install the mysql <<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[34m>>>>>>> start and enable MYSQl >>>>>>>\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[34m>>>>>>> Set root pass >>>>>>>\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1