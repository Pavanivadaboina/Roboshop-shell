script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

rabbitmq_user_password=$1


if [ -z "$rabbitmq_user_password" ];
then
  echo input password is missing
  exit 1
fi

component=payment

func_python

