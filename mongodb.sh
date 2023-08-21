cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
sed -i -e 's|127.0.0.0|0.0.0.0|' /etc/mongod.conf
#edit the file and replace 127.0.0.1 to 0.0.0.0
systemctl restart mongod