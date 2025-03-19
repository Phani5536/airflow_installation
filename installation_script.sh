#!/bin/bash

# Exit on error
set -e

# Print commands before executing
set -x

# Variables
AIRFLOW_HOME=~/airflow_folder/airflow
AIRFLOW_VERSION=2.9.0
PYTHON_VERSION="3.10" 
 
# Update packages
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.10 python3.10-dev python3.10-venv python3.10-distutils

# Create Airflow directory
mkdir -p $AIRFLOW_HOME
cd $AIRFLOW_HOME

# Create and activate virtual environment
python3.10 -m venv airflow_env
source airflow_env/bin/activate

# Install pip in the virtual environment
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Install Airflow
export AIRFLOW_HOME=$AIRFLOW_HOME
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

pip freeze > $AIRFLOW_HOME/requirements.txt

# Initialize the database
airflow db init

# Create admin user (non-interactive)
airflow users create \
  --username admin \
  --firstname Admin \
  --lastname User \
  --role Admin \
  --email admin@example.com \
  --password admin

# Create daemon script for Airflow
cat > $AIRFLOW_HOME/start_airflow.sh << 'EOL'
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
EOL

# Create stop script
cat > $AIRFLOW_HOME/stop_airflow.sh << 'EOL'
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
EOL

# Make scripts executable
chmod +x $AIRFLOW_HOME/start_airflow.sh
chmod +x $AIRFLOW_HOME/stop_airflow.sh

# Add environment variables to .bashrc
echo "export AIRFLOW_HOME=$AIRFLOW_HOME" >> ~/.bashrc
echo "export PATH=\$PATH:$AIRFLOW_HOME/airflow_env/bin" >> ~/.bashrc

# Source the updated .bashrc
source ~/.bashrc

# Start Airflow
$AIRFLOW_HOME/start_airflow.sh

echo "Airflow installation completed successfully!"
