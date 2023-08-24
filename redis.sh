script=$(realpath "$0")
script_path=$(dirname "$script")
source=$(script_path)/common.sh

echo -e "\e[34m>>>>>>> Install Redis Repo >>>>>>>\e[0m"

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[34m>>>>>>> Enable Redis Version 6.2  >>>>>>>\e[0m"
yum module enable redis:remi-6.2 -y

echo -e "\e[34m>>>>>>> Install Redis >>>>>>>\e[0m"
yum install redis -y

echo -e "\e[34m>>>>>>> Upadte Listen Address  >>>>>>>\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf
#Update listen address from 127.0.0.1 to 0.0.0.0

echo -e "\e[34m>>>>>>> Restart redis >>>>>>>\e[0m"
systemctl enable redis
systemctl restart redis
