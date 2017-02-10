#!/bin/bash
# Add new port in SSHD service, allow in firewalld, add port in to selinux in CentOS

PORT=2020

# Add a permanent port to a file
firewall-cmd --add-port=$PORT/tcp --permanent
firewall-cmd --reload

# Install semanage components and add port to semanage
yum install policycoreutils-python -y
semanage port -a -t ssh_port_t -p tcp $PORT
sleep 10
semanage port -l | grep ssh

# Backup config. Change sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "" > /etc/ssh/sshd_config

cat >>/etc/ssh/sshd_config <<EOF
Port 2020
Protocol 2
SyslogFacility AUTHPRIV
PermitRootLogin no
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile  .ssh/authorized_keys
PasswordAuthentication yes
ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
UsePAM yes
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
X11Forwarding yes
Subsystem sftp  /usr/libexec/openssh/sftp-server
EOF

systemctl restart sshd

# cat <<EOF>> /etc/ssh/sshd_config
# some lines
# of text
# EOF