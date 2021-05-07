# OMEROimport

Author: Laura Cooper, CAMDU, University of Warwick
Contact: CAMDU@warwick.ac.uk

## Description
A series of commands that can be combined to set up automatic imports from microscopes. The commands are designed to output concise messages so it is easy to quickly spot issues. Verbose output is passed to a log file that can be accessed when more details are required.
Data older than 31 days is moved to a folder called OldData. This makes it easy to monitor data/files that have been on the microscope computer for a long time to prevent the hard drive becoming full. Data that is imported to OMERO is moved to an Imported folder so that users can check their data has been correctly stored in OMERO before deleting it from the microscope computer.

## OMERO requirements
- A user with sudo and create users privileges to act as the importer
- LDAP authentication enabled

## Installation for Windows 10 using Windows Subsystem Linux
1. Enable Windows Subsystem Linux (WSL)
2. Install Ubuntu from Microsoft Store
3. Set up Ubuntu
4. Run the following commands to install the dependencies:
    ```
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get install -y git python3 python3-pip python3-venv python3-dev python3-wheel
    sudo apt-get install -y build-essential libssl-dev libbz2-dev software-properties-common
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt-get update -q
    sudo apt-get -y upgrade
    sudo apt-get install -y openjdk-11-jre
    python3 -m venv omero-env
    source ./omero-env/bin/activate
    pip3 install omero-py>=5.8.1
    ```
5. Clone the repo
6. Create a configuration file that contains:
    ```
    server=server.name
    port=xxxx
    username=importer_name
    ```
   See Example/import.cfg for an example configuration file.
7. Create a password file containing the password for your importer

For summary of commands run

$ bash OMEROimport --help

## Setting up for automatic imports
An example use of how the commands can be used to set up an automatic import can be found in Example/MicroscopeImport.sh. There are six parameters at the start that should be set for the computer running the import. This is an example of how the commands can be run together, as suits our purposes. You should edit the sequence to fit your requirements

1. Add a file to the folder to be imported. This file must be called .username.txt and contain the OMERO username for the person who's data is being imported.
2. Make sure that the Windows user which will be running the automatic import has approriate permissions on all the required folders.
3. Create a .bat file to run the import, the contents should look something like this: \
   `wsl cd /home/user/Autoimport; bash MicroscopeImport.sh > task.log`
4. Use Task schedular to set up when .bat file should run



