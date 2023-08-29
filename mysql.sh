script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

mysql_root_password=$1

if [ -z "$mysql_root_password" ];
then
  echo input password is missing
  exit 1
fi


print_head " Disbale modyule sql version 8 "
yum module disable mysql -y &>>$log_file
func_status_check $?

print_head "Configure Mysql repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

print_head "Install the mysql"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

print_head "start and enable MYSQl"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

print_head " Reset root pass "
mysql_secure_installation --set-root-pass $mysql_root_password  &>>$log_file
func_status_check $?
