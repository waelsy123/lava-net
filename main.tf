provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "lava-testnet" {
  ami           = "ami-00874d747dde814fa" // ubunto 22.04 64bit
  instance_type = "c4.xlarge"
  key_name      = "wasim-mac"

  tags = {
    Name = "lava-testnet"
  }

  user_data = <<-EOF
#!/bin/bash

# installing Node.js pm2 and http-server
sudo apt-get update
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
apt-get install -y nodejs
apt-get install -y git
npm install pm2 -g
npm install http-server -g

sudo apt update # in case of permissions error, try running with sudo
sudo apt install -y unzip logrotate git jq sed wget curl coreutils systemd

cd /home/ubuntu

git clone https://github.com/waelsy123/lava-net.git
chmod 777 lava-net
sudo -H -u ubuntu bash -c 'lava-net/setup.sh' 

  EOF
}
