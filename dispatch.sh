script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "install golong"
yum install golang -y &>>log_file
func_status_check
func_app_prereq
go mod init dispatch
go get
go build
func_systemd
func_status_check