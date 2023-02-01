#!/bin/bash

# su ubuntu
# echo "$PWD" >> pwddd

# # installing Node.js pm2 and http-server
# sudo apt-get update
# # Install Node.js and npm
# curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
# apt-get install -y nodejs
# # Install git
# apt-get install -y git
# # Install the pm2 package
# npm install pm2 -g
# npm install http-server -g

# ## intall go

# cd 
# echo "$PWD"

# sudo apt update # in case of permissions error, try running with sudo
# sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd

# Download GO
wget -q https://go.dev/dl/go1.18.linux-amd64.tar.gz

# Unpack the GO installation file
sudo tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz
# Environment adjustments
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
echo "export PATH=\$PATH:\$(go env GOPATH)/bin" >> ~/.profile
source ~/.profile

# Download the installation setup configuration
cd /home/ubuntu
git clone https://github.com/lavanet/lava-config.git
cd lava-config/testnet-1
# Read the configuration from the file
# Note: you can take a look at the config file and verify configurations
source setup_config/setup_config.sh

echo "Lava config file path: $lava_config_folder"
mkdir -p $lavad_home_folder
mkdir -p $lava_config_folder
cp default_lavad_config_files/* $lava_config_folder

# Copy the genesis.json file to the Lava config folder
cp genesis_json/genesis.json $lava_config_folder/genesis.json

echo "debug 1"

## setup Cosmovisor
source ~/.profile
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0

echo "debug 1"

# Create the Cosmovisor folder and copy config files to it
mkdir -p $lavad_home_folder/cosmovisor

echo $lavad_home_folder >> a
which go >> cosmovisor
which cosmovisor >> cosmovisor

# Download the latest cosmovisor-upgrades from S3
wget https://lava-binary-upgrades.s3.amazonaws.com/testnet/cosmovisor-upgrades/cosmovisor-upgrades.zip
unzip cosmovisor-upgrades.zip
cp -r cosmovisor-upgrades/* $lavad_home_folder/cosmovisor

# Set the environment variables
echo "# Setup Cosmovisor" >> ~/.profile
echo "export DAEMON_NAME=lavad" >> ~/.profile
echo "export CHAIN_ID=lava-testnet-1" >> ~/.profile
echo "export DAEMON_HOME=/.lava" >> ~/.profile
echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=true" >> ~/.profile
echo "export DAEMON_LOG_BUFFER_SIZE=512" >> ~/.profile
echo "export DAEMON_RESTART_AFTER_UPGRADE=true" >> ~/.profile
echo "export UNSAFE_SKIP_BACKUP=true" >> ~/.profile
source ~/.profile

# Initialize the chain
$lavad_home_folder/cosmovisor/genesis/bin/lavad init \
my-node \
--chain-id lava-testnet-1 \
--home $lavad_home_folder \
--overwrite
cp genesis_json/genesis.json $lava_config_folder/genesis.json

# Create Cosmovisor unit file

echo "[Unit]
Description=Cosmovisor daemon
After=network-online.target
[Service]
Environment="DAEMON_NAME=lavad"
Environment="DAEMON_HOME=/.lava"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="UNSAFE_SKIP_BACKUP=true"
User=$USER
ExecStart=/go/bin/cosmovisor start --home=$lavad_home_folder --p2p.seeds $seed_node
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity
[Install]
WantedBy=multi-user.target
" >cosmovisor.service
sudo mv cosmovisor.service /lib/systemd/system/cosmovisor.service
