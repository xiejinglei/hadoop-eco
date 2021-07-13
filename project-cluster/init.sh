#!/bin/bash

apt-get update

mkdir /ta-su2020/
cd /ta-su2020
git clone https://github.com/xiejinglei/hadoop-eco.git

bash /ta-su2020/hadoop-eco/project-cluster/install-docker.sh