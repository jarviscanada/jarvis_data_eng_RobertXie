# Linux Cluster Monitoring Agent
## Introduction
The Linux Cluster Monitoring Agent allows users to record the hardware specifications of each node and monitor node resource usage in real time. It collects data on system metrics such as CPU usage, memory consumption, disk I/O, and network activity from each node. 
## Quick Start
The following steps will get the Linux Cluster Monitoring Agent up and running with docker installed.
```
# Create a psql docker container with the given username and password
./scripts/psql_docker.sh create db_username db_password

# Start a psql instance using psql_docker.sh
./scripts/psql_docker.sh start

# Create tables using ddl.sql
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# Insert hardware specs data into the DB using host_info.sh
bash scripts/host_info.sh psql_host psql_port db_name psql_user psql_password

# Insert hardware usage data into the DB using host_usage.sh
bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password

# Crontab setup
crontab -e
* * * * * bash [Absolute Path to host_usage.sh] host_address psql_port db_name db_username db_password > /tmp/host_usage.log
```
## Implementation
how I implement the proj
## Architecture
a cluster diagram
## Scripts
`psql_docker.sh`: This script 
`host_info.sh`:
`host_usage.sh`:
`crontab`:
`queries.sql`:
## Database Modeling
`host_info`:
| id | hostname | cpu_number | cpu_architecture |             cpu_model          | cpu_mhz | l2_cache |        timestamp        | total_mem |
|----|----------|------------|------------------|--------------------------------|---------|----------|-------------------------|-----------|
| 1  |   noe1   |      1     |      x86_64      | Intel(R) Xeon(R) CPU @ 2.30GHz |   2300  |    256   | 2019-05-29 17:49:53.000 |   601324  |


