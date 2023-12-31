script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh




print_head " install Nginx "
yum install nginx -y &>>$log_file
func_status_check $?

print_head " System start nginx "
systemctl enable nginx &>>$log_file
systemctl start nginx  &>>$log_file
func_status_check $?

print_head " remove default versions "
rm -rf /usr/share/nginx/html/*  &>>$log_file
func_status_check $?

print_head "Download the application content "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?

print_head " unzip the application content "
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?

print_head " setup systemD service "
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status_check $?

print_head " restart nginx "
systemctl restart nginx &>>$log_file
func_status_check $?
