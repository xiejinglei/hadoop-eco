#!/bin/bash

if [ ! -d "/home/hadoop" ]; then
    mkdir -p /home/hadoop
    chown -R hadoop:hadoop /home/hadoop
fi
echo "hadoop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

service ssh start

chmod -R 777 ${HADOOP_HOME}/logs
chown -R hadoop:hadoop ${HADOOP_HOME}/logs
chmod -R 777 ${DRILL_HOME}/log
chown -R hadoop:hadoop ${DRILL_HOME}/log
