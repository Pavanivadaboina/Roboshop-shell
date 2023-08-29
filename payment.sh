script=$(realpath "$0")
script_path=$(dirname "$script")
source $(script_path)/common.sh

rabbitmq_user_password=$1


if [ -z "$rabbitmq_user_password" ];
then
  echo input password is missing
  exit
fi


print_head "Install Python"
yum install python36 gcc python3-devel -y &>>log_file
func_status_check $?

func_app_prereq()

print_head "Install Python Dependencies"
cd /app &>>$log_file
pip3.6 install -r requirements.txt &>>$log_file
func_status_check $?

print_head  "Setup SystemD Payment service"
sed -i -e 's|rabbitmq_user_password|${rabbitmq_user_password}|' ${script_path}/payment.service &>>$log_file
cp ${script_path}/payment.service /etc/systemd/system/payment.service &>>$log_file
func_status_check $?

print_head "load and restart"
systemctl daemon-reload &>>$log_file
systemctl enable payment &>>$log_file
systemctl start payment &>>$log_file
func_status_check $?