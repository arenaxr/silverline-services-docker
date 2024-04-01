#!/bin/sh
# writes env variables to /etc/telegraf/telegraf.conf (overrriding telegraf.dft.conf)
# supports:
#    TCONF_CONF_FILE: **input** config filename (default: /telegraf.dft.conf)
# .  TCONF_MQTT_SERVER: mqtt server; for some reason, telegraf env substitution not working for MQTT_SERVER
#

dft_config_file=${TCONF_CONF_FILE:-/telegraf.dft.conf}
out_config_file=/etc/telegraf/telegraf.conf
echo "Config file: "$dft_config_file => $out_config_file

# replace MQTT_SERVER for value of TCONF_MQTT_SERVER
if [ ! -z "$TCONF_MQTT_SERVER" ]; then
    echo "Replacing MQTT_SERVER: $TCONF_MQTT_SERVER"
    cat $dft_config_file | sed 's|\"\$MQTT_SERVER\"|'$TCONF_MQTT_SERVER'|g' > $out_config_file
fi 

# start telegraf
/entrypoint.sh telegraf
