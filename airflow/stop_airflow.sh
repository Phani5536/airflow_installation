#!/bin/bash
export AIRFLOW_HOME=~/airflow_folder/airflow

if [ -f $AIRFLOW_HOME/webserver.pid ]; then
    kill $(cat $AIRFLOW_HOME/webserver.pid)
    rm $AIRFLOW_HOME/webserver.pid
    echo "Airflow webserver stopped"
fi

if [ -f $AIRFLOW_HOME/scheduler.pid ]; then
    kill $(cat $AIRFLOW_HOME/scheduler.pid)
    rm $AIRFLOW_HOME/scheduler.pid
    echo "Airflow scheduler stopped"
fi
