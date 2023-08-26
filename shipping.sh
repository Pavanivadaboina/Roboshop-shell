script=$(realpath "$0")
script_path=$(dirname "$script")
source $(script_path)/common.sh

mysql_root_password=$1

if [ -z "$mysql_root_password" ];
then
  echo input password is missing
  exit
fi

component=shipping
func_java

schema_setup=mysql