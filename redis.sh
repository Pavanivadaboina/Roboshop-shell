script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



print_head "Install Redis Repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_status_check $?

print_head "Enable Redis Version 6.2"
yum module enable redis:remi-6.2 -y &>>$log_file
func_status_check $?

print_head "Install Redis"
yum install redis -y &>>$log_file
func_status_check $?

print_head "Upadte Listen Address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
#Update listen address from 127.0.0.1 to 0.0.0.0
func_status_check $?

print_head "Restart redis "
systemctl enable redis &>>$log_file
systemctl restart redis  &>>$log_file
func_status_check $?
