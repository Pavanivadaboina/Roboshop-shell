script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user

func_nodejs
func_systemd
schema_setup=mongo