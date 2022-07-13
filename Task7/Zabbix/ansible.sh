#!/bin/bash
echo "=============================START OF FILE==============================="
apt-get update
apt-get install -y python3-pip
pip3 install ansible
apt-get install -y selinux-utils
echo "================================MariaDB=================================="
apt-get install curl software-properties-common -y
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
bash mariadb_repo_setup --mariadb-server-version=10.7
apt-get update
apt-get install -y mariadb-server
echo "================================Zabbix==================================="
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-3+ubuntu20.04_all.deb
dpkg -i zabbix-release_6.0-3+ubuntu20.04_all.deb
apt-get update
apt-get -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
echo "==============================END OF FILE================================"
