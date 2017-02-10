#!/bin/bash

port=2020

yum install policycoreutils-python -y

firewall-cmd --add-port=$port/tcp --permanent
firewall-cmd --reload

semanage port -a -t ssh_port_t -p tcp $port

semanage port -l | grep ssh

