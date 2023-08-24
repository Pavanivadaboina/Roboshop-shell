script=$(realpath "$0")
script_path=$(dirname "$script")
source=${script_path}/common.sh

echo -e "\e[32m>>>>>>> Inatsll NGINIX >>>>>>>\e[0m"
yum install nginx -y

echo -e "\e[32m>>>>>>> Start Nginx >>>>>>>\e[0m"
systemctl enable nginx
systemctl start nginx

echo -e "\e[32>>>>>>> remove default code <<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[32m>>>>>>> Download the App Content <<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[32m >>>>>>> Unzip App Content <<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[32m >>>>>>> Set up SystemD Service <<<<<<<\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[32m >>>>>>> Restart Nginx <<<<<<<\e[0m"
systemctl restart nginx

