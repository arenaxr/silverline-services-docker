# Compose stack for silverline services

Creates several containers with Silverline services:

* Orchestrator
* Demo Runtime
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

- Edit `MQTT_SERVER`, `DASHBOARD_ORCHESTRATOR_API_HOST` and `DASHBOARD_ORCHESTRATOR_API_PORT` in **.env**. This should reflect your setup.

```bash
...

# MQTT
MQTT_SERVER=tcp://mqtt-broker-address:mqtt-broker-port

# Dashboard
DASHBOARD_PORT=dashboard-port
DASHBOARD_ORCHESTRATOR_API_HOST=orchestrator-host
DASHBOARD_ORCHESTRATOR_API_PORT=orchestrator-port
...
```

* ```MQTT_SERVER``` is the MQTT server address (e.g. `MQTT_SERVER=tcp://arena-dev1.conix.io:11883`).
* ```DASHBOARD_ORCHESTRATOR_API_HOST``` indicates the host of the orchestrator where REST calls are available (e.g. 
* ```DASHBOARD_PORT``` indicates the port exposed for the dashboard (e.g. `DASHBOARD_ORCHESTRATOR_API_HOST=80`; optional)
`DASHBOARD_ORCHESTRATOR_API_HOST=arena-dev1.conix.io`)
* ```DASHBOARD_ORCHESTRATOR_API_PORT``` indicates the port of the orchestrator where REST calls are available (e.g. `DASHBOARD_ORCHESTRATOR_API_PORT=18000`)

> Optionally, for a more secure setup, you can change the `DOCKER_INFLUXDB_INIT_PASSWORD` and `DOCKER_INFLUXDB_INIT_ADMIN_TOKEN`. They can be any random secret string.

4. You should be good to start all services in background (`-d`) using `docker-compose`:

```bash
 docker-compose up -d
```

### Update dashboard

To update with the lastest source:

```bash
git pull --recurse-submodules
git submodule update
docker-compose up -d --no-deps --build dashboard
```