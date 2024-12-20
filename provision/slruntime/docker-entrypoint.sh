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
#    RTCONF_REG_FAIL_ERROR: error on a registration failure
#    RTCONF_MAX_NMODULES: runtime max number of modules
#    RTCONF_REALM: runtime realm
#    RTCONF_KA_INTERVAL_SEC: keepalive interval
#    RTCONF_HOST: runtime mqtt host
#    RTCONF_PORT: runtime mqtt port
#    RTCONF_SSL: runtime uses ssl on mqtt connection (true/false)
#    RTCONF_URL: appstore url
#

dft_config_file=${CONF_FILE:-config/settings.dft.yaml}
echo "Config file: "$dft_config_file
out_config_file=config/settings.yaml
cp $dft_config_file $out_config_file

dft_appconfig_file=${APPCONF_FILE:-config/appsettings.dft.yaml}
echo "App config file: "$dft_appconfig_file
out_appconfig_file=config/.appsettings.yaml
cp $dft_appconfig_file $out_appconfig_file

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

declare -a config_keys=("name" "uuid" "reg_attempts" "reg_timeout_seconds" "max_nmodules" "realm" "host" "port" "ssl" "reg_fail_error" "ka_interval_sec" "url")
for key in "${config_keys[@]}"
do
  conf_key=RTCONF_`echo $key | tr '[:lower:]' '[:upper:]'`
  if [[ ! -z "${!conf_key}" ]]; then
    echo  "Replacing conf: "${key}:${!conf_key}
    sed -i "s/$key\:.*/$key\: ${!conf_key}/" $out_config_file
  fi 
done 

echo "#### $out_config_file ####"
cat $out_config_file

echo "#### $out_appconfig_file ####"
cat $out_appconfig_file

python src/main.py --daemon