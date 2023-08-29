script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



print_head "Configure mongo repo"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
func_status_check $?

print_head "Install Mongo software"
yum install mongodb-org -y
func_status_check

print_head "enable and Start mongod"
systemctl enable mongod
systemctl start mongod
func_status_check $?

print_head " replace the IP Address "
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
#edit the file and replace 127.0.0.1 to 0.0.0.
func_status_check $?

print_head "restart mongod "
systemctl restart mongod
func_status_check $?