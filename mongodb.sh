script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[34m>>>>>>> Configure mongo repo >>>>>>>\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>> Install Mongo software  >>>>>>>\e[0m"
yum install mongodb-org -y

echo -e "\e[34m>>>>>>> enable and start mongod  >>>>>>>\e[0m"
systemctl enable mongod
systemctl start mongod

echo -e "\e[34m>>>>>>> Update listen address  >>>>>>>\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
#edit the file and replace 127.0.0.1 to 0.0.0.

echo -e "\e[34m>>>>>>> Restart mongo  >>>>>>>\e[0m"
systemctl restart mongod