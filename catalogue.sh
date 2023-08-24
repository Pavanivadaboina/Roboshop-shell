script=$(realpath "$0")
script_path=$(dirname "$script")
source=${script_path}/common.sh

component=catalogue

func_nodejs

echo -e "\e[34m>>>>>>> copy mongo repo    >>>>>>>\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[34m>>>>>>> Install mongo client   >>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[34m>>>>>>> Load Mongo Schema   >>>>>>>\e[0m"
mongo --host mongo.devopspractice.tech </app/schema/catalogue.js
