#!/bin/bash
export AIRFLOW_HOME=~/airflow_folder/airflow
source $AIRFLOW_HOME/airflow_env/bin/activate

# Start scheduler in background
airflow scheduler > $AIRFLOW_HOME/scheduler.log 2>&1 &
echo $! > $AIRFLOW_HOME/scheduler.pid

# Start webserver in background
airflow webserver --port 8080 > $AIRFLOW_HOME/webserver.log 2>&1 &
echo $! > $AIRFLOW_HOME/webserver.pid

echo "Airflow started. Access the web UI at http://localhost:8080"
echo "Username: admin, Password: admin"
echo "Logs are saved in $AIRFLOW_HOME/scheduler.log and $AIRFLOW_HOME/webserver.log"
echo "To stop Airflow, run: $AIRFLOW_HOME/stop_airflow.sh"
