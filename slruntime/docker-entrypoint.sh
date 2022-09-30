#!/bin/bash
# writes env variables to config/settings.yaml (overrriding settings.dft.yaml) and secrets file
# supports:
#    RTCONF_SECRETS_FILE: output secrets filename (default: config/.secrets.yaml) if blank, user and password are ignored
#    RTCONF_MQTT_USER: writes user into password file 
#    RTCONF_MQTT_PWD: writes password into password file 
#    RTCONF_NAME: runtime name 
#    RTCONF_UUID: runtime uuid
#    RTCONF_REG_ATTEMPTS: runtime reg attempts
#    RTCONF_REG_TIMEOUT_SECONDS: runtime reg timeout
#    RTCONF_MAX_NMODULES: runtime max number of modules
#    RTCONF_REALM: runtime realm
#    RTCONF_HOST: runtime mqtt host
#    RTCONF_PORT: runtime mqtt port
#    RTCONF_SSL: runtime uses ssl on mqtt connection (true/false)
#
# also wait for it config:
#    WAIT_FOR_OPTIONS: wait-for-it.sh args. e.g.: -t <time> <service>:<port>

dft_config_file=${RTONF_CONF_FILE:-config/settings.dft.yaml}
echo "Config file: "$dft_config_file
out_config_file=config/settings.json
cp $dft_config_file $out_config_file

if [[ ! -z "${RTCONF_SECRETS_FILE}" ]]; then
echo "Creating ${RTCONF_SECRETS_FILE} from env."
cat <<EOT > ${RTCONF_SECRETS_FILE}
# auto-generated file
dynaconf_merge: true # merge with config in settings.yaml (required)
mqtt:
  username: ${RTCONF_MQTT_USER}
  password: ${RTCONF_MQTT_PWD}
EOT

fi

declare -a config_keys=("name" "uuid" "reg_attempts" "reg_timeout_seconds" "max_nmodules" "realm" "host" "port" "ssl")
for key in "${config_keys[@]}"
do
  conf_key=RTCONF_`echo $key | tr '[:lower:]' '[:upper:]'`
  if [[ ! -z "${!conf_key}" ]]; then
    echo  "Replacing conf: "${key}:${!conf_key}
    sed -i "s/$key\:.*/$key\:${!conf_key}/" $out_config_file
  fi 
done 

./wait-for-it.sh ${WAIT_FOR_OPTIONS:- -t 30 orchestrator:8000}

python src/main.py --daemon