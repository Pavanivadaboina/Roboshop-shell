script=$(realpath "$0")
script_path=$(dirname "$script")
source=$(script_path)/common.sh

echo -e "\e[34m>>>>>>> Setup Erlang repos <<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[34m>>>>>>> Setup RabbitMQ Repos <<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[34m>>>>>>> Install RabbitMQ <<<<<<<\e[0m"
yum install rabbitmq-server -y

echo -e "\e[34m>>>>>>> enable and start RabbitMQ <<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[34m>>>>>>> Create Application User in RabbitMQ <<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"