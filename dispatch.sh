script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

yum install golang -y
func_app_prereq
go mod init dispatch
go get
go build
func_systemd