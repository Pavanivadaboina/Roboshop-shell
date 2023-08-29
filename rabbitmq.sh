script=$(realpath "$0")
script_path=$(dirname "$script")
source $(script_path)/common.sh

rabbitmq_user_password=$1

if [ -z "$rabbitmq_user_password" ];
then
  echo input password is missing
  exit
fi


print_head "Setup Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>log_file
func_status_check $?

print_head "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>log_file
func_status_check $?

print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>log_file
func_status_check $?

print_head "enable and start RabbitMQ"
systemctl enable rabbitmq-server &>>log_file
systemctl start rabbitmq-server &>>log_file
func_status_check $?

print_head Create Application User in RabbitMQ"
rabbitmqctl add_user roboshop $rabbitmq_user_password &>>log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>log_file
func_status_check $?