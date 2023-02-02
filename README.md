# lava-net

## lavanet Deployment on AWS and other cloud providers

This repository contains Terraform scripts and deployment scripts for lavanet blockchain on AWS and other cloud providers like DigitalOcean. The goal of this repository is to make it easy to deploy lavanet nodes quickly and efficiently.

## Requirments

1. terraform cli
2. ~/.aws/credentials file with 'aws_access_key_id' and 'aws_secret_access_key'

# Contents

1. Makefile scripts for easy deployment and destruction of instances, including an immediate SSH connection string for the EC2 instance.
   EC2 instance with the minimum hardware requirements for running lavanet.
2. Setup script to automate the installation and configuration of required packages.
   Deployment
3. To deploy lavanet on AWS or other cloud providers, simply run the following command:

```
make deploy
```

This will automatically create a new EC2 instance with the minimum hardware requirements, install and configure the required packages, and start the lavanet node.

# SSH Connection String

After running the make deploy command, you will receive the SSH connection string for the EC2 instance, allowing you to connect and manage the node.

## Check the status of the service

```
 sudo systemctl status cosmovisor
```

## To view the service logs - to escape, hit CTRL+C

```
sudo journalctl -u cosmovisor -f
```

## Check if the node is currently in the process of catching up

```
lavad status | jq .SyncInfo.catching_up
```
