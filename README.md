# Compose stack for silverline services

Creates several containers with Silverline services:

* Orchestrator
* Demo Runtime [TODO]
* Web server for dashboard (Nginx)
* Database (influxdb)
* Metrics Agent (telegraf)
* Plots (Graphana)

The dashboard is a submodule of this repo. Orchestrator and runtime are started from pre-built images. The nginx container serves the dashboard files and acts as proxy.

## Quick Setup

1. We need [docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/). 

2. Clone this repo (with ```--recurse-submodules``` to make sure you get the contents of the repositories added as submodules):

```bash
git clone https://github.com/arenaxr/silverline-services-docker.git --recurse-submodules
```

3. Modify configuration:


- Copy the example configuration `env.default` to `.env`
```bash
cp env.default .env
```

**If you have a arena-services-docker setup on the same machine, you can skip the MQTT section, as `compose-from-arena-services.sh` will fetch this configuration from arena-services-docker**

- Edit `MQTT_SERVER`, `MQTT_SERVER_PORT`, `MQTT_WEBHOST`, `MQTT_WEBHOST_PATH`, `MQTT_TOPIC`, `MQTT_USER`, `MQTT_PWD`,`DASHBOARD_ORCHESTRATOR_API_HOST` and `DASHBOARD_ORCHESTRATOR_API_PORT` in **.env**. This should reflect your setup.

```bash
...

# MQTT
# mqtt broker; e.g.: arena-dev1.conix.io (compose-from-arena-services.sh will get this config from arena-services-docker)
MQTT_SERVER=broker-host
# mqtt broker port; e.g.: 8883 (compose-from-arena-services.sh will get this config from arena-services-docker)
MQTT_SERVER_PORT=broker-port
# mqtt broker host for websocket connections; e.g.: arena-dev1.conix.io (compose-from-arena-services.sh will get this config from arena-services-docker)
MQTT_WEBHOST=broker-web-host 
# mqtt broker endpoint for websocket connections; 'mqtt' is usually a safe default
MQTT_WEBHOST_PATH=mqtt
# keepalive topic; this is usually a safe default
MQTT_TOPIC=realm/proc/keepalive/# 
# mqtt username; e.g.: cli (compose-from-arena-services.sh will get this config from arena-services-docker)
MQTT_USER=auser
# mqtt password; e.g.: a very long JWT: eyJ0eXAiOiJKV1QiLCJhbGc...  (compose-from-arena-services.sh will get this config from arena-services-docker)
MQTT_PWD=apasswd

# Dashboard 
# port exposed for the dashboard; e.g. 8001
DASHBOARD_PORT=dashboard-port
# host of the orchestrator where REST calls are available; e.g. arena-dev1.conix.io
DASHBOARD_ORCHESTRATOR_API_HOST=orchestrator-host
# orchestrator api port; e.g. 8000
DASHBOARD_ORCHESTRATOR_API_PORT=orchestrator-port
...
```
> Optionally, for a more secure setup, you can change the `DOCKER_INFLUXDB_INIT_PASSWORD` and `DOCKER_INFLUXDB_INIT_ADMIN_TOKEN`. They can be any random secret string.

4. You should be good to start all services in background (`-d`) using `docker-compose`:

```bash
 docker-compose up -d
```

**If you have a arena-services-docker setup on the same machine, instead use `compose-from-arena-services.sh` to fetch configuration from arena-services-docker:**
```bash
 ./compose-from-arena-services.sh up -d
```

### Update dashboard

To update with the lastest source:

```bash
git pull --recurse-submodules
git submodule update
docker-compose up -d --no-deps --build dashboard
```