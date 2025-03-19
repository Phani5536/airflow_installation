# airflow_installation

# Apache Airflow 2.9 Installation on WSL Ubuntu

This repository contains a script for automated installation of Apache Airflow 2.9 with Python 3.10 on Windows Subsystem for Linux (WSL) Ubuntu.

## Features

- Installs Python 3.10 from deadsnakes PPA
- Sets up a dedicated virtual environment for Airflow
- Installs Apache Airflow 2.9.0 with proper constraints
- Creates admin user for the web interface
- Includes startup and shutdown scripts
- Configures environment variables automatically

## Prerequisites

- Windows Subsystem for Linux (WSL) installed
- Ubuntu distribution set up within WSL
- Sudo privileges on your Ubuntu installation

## Installation

1. Clone this repository or download the installation script
2. Make the script executable:
   ```bash
   chmod +x installation_script.sh
   ```
3. Run the script:
   ```bash
   ./installation_script.sh
   ```

## Usage

After installation completes, you can:

### Access the Web UI
- Open a browser and navigate to `http://localhost:8080`
- Login with:
  - Username: `admin`
  - Password: `admin`

### Manage Airflow Services
- To stop Airflow:
  ```bash
  ~/airflow/stop_airflow.sh
  ```
- To start Airflow (after installation or after stopping):
  ```bash
  ~/airflow/start_airflow.sh
  ```

### Check Logs
- Scheduler logs: `~/airflow/scheduler.log`
- Webserver logs: `~/airflow/webserver.log`

## Service Scripts Explained

### Start Script (`start_airflow.sh`)
This script activates the virtual environment and starts both the Airflow scheduler and webserver as background processes. It redirects their output to log files and saves their process IDs for later management.

### Stop Script (`stop_airflow.sh`)
This script gracefully terminates the running Airflow processes using the saved process IDs.
