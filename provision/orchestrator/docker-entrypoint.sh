#!/bin/bash
# writes env variables to config.json
# important:
#    - default json config file must exist and have the entries with some default values
#    - a string value in the json config must have double quotes
# supports:
#    OCONF_CONF_FILE: **input** json config filename (default: config.docker.json)
#    OCONF_PWD_FILE_CONTENTS: writes env var value into password file (password filename as given in config file)
#    OCONF_<any key in config file in caps: HTTP, HTTP_PORT, DEBUG>: set the value of any entry in the config file 
#
dft_config_file=${OCONF_CONF_FILE:-config.dft.json}
echo "Config file: "$dft_config_file
pwd_file=$(grep '"pwd"' $dft_config_file | cut -d'"' -f 4)
echo "Pwd file   : "$pwd_file
out_config_file=config.json
cp $dft_config_file $out_config_file
if [[ ! -z "${OCONF_PWD_FILE_CONTENTS}" ]]; then
  echo "Creating mqtt_pwd.txt from env."
  echo ${OCONF_PWD_FILE_CONTENTS} > $pwd_file
fi

config_keys=$(tail -n +2 $dft_config_file | head -n -1 | cut -d':' -f1 | sed 's/\"//g')
for key in $config_keys
do
  conf_key=OCONF_`echo $key | tr '[:lower:]' '[:upper:]'`
  if [[ ! -z "${!conf_key}" ]]; then
    echo  "Replacing conf: "${key}:${!conf_key}
    echo sed -i "s/\"$key\"\:.*/\"$key\"\:${!conf_key},/" $out_config_file
    sed -i "s/\"$key\"\:.*/\"$key\"\:${!conf_key},/" $out_config_file
  fi 
done 

config_port=$(grep '"http_port"' $out_config_file | cut -d':' -f2 | sed 's/[^0-9]*//g')
port=${config_port:-8000}
echo "Starting on orchestrator with settings: "
cat $out_config_file
echo

make migrate
python manage.py runserver 0.0.0.0:$port
