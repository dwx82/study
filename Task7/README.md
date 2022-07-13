```bash

Step 0: Create AWS infrastructure

####################################################################################################

Step 1: Install Zabbix

bootstrap script +

sudo mysql_secure_installation
mysql -uroot -p

create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'password';
grant all privileges on zabbix.* to zabbix@localhost;
quit;

zcat /usr/share/doc/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p zabbix

Edit file /etc/zabbix/zabbix_server.conf

DBPassword=password

####################################################################################################

Step 2: Install Zabbix Agents

https://docs.ansible.com/ansible/latest/collections/community/zabbix/zabbix_host_module.html
https://github.com/ansible-collections/community.zabbix/blob/main/docs/ZABBIX_AGENT_ROLE.md

On zabbix server:
ansible-galaxy collection install community.zabbix
sudo pip install zabbix-api #sudo is mandatory

sudo systemctl restart zabbix-server zabbix-agent apache2 mariadb
sudo systemctl  enable zabbix-server zabbix-agent apache2 mariadb

Run the playbook.
That`s all. All agents will be added automatically. It`s some kind of magic )    

ansible_hostname on ec2 converts it to IP.
Use Resource name on ec2 or enable discovery and autoregistration in zabbix.




           DON`T USE COMMENTS IN THE PLAYBOOK AND IN THE VAR FILE.




####################################################################################################

Step 3: Read docs and select necessary checkboxes.  

########################################ELK#########################################################

Step 4: Configure ELK Docker and host
https://www.youtube.com/watch?v=6bXSfjwQVIc
https://logz.io/learn/docker-monitoring-elk-stack/
https://www.youtube.com/watch?v=VpAH2IoMzKw
https://www.youtube.com/watch?v=DY3G0XsvvEw&list=PLnWmZqALnx9Cbq2ddlMjMxol7s_1DFL-u

MetrickBeat

curl -L -O https://raw.githubusercontent.com/elastic/beats/7.17/deploy/docker/metricbeat.docker.yml
https://github.com/shazChaudhry/docker-elastic/blob/master/metricbeat-docker-compose.yml

I will deploy the following scheme:


                  FileBeat --> Logstash --> Elasticseach --> Kibana


On the host I installed filebeat and MetrickBeat (to get metrics).

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list


FileBeat
sudo apt-get update && sudo apt-get install filebeat metricbeat
sudo systemctl enable filebeat

sudo metricbeat modules enable kibana-xpack

sudo metricbeat modules enable logstash-xpack

sudo metricbeat modules enable elasticsearch-xpack # xpack.monitoring.elasticsearch.collection.enabled": false

sudo metricbeat modules enable beat-xpack     

MetrickBeat config:

output.elasticsearch:
  hosts: ["http://localhost:9200"]
  username: "elastic"
  password: "changeme"


curl -X GET -u elastic:test "localhost:9200/_cluster/state/blok?pretty"
#in case stand alone cluster we will need cluster id

FileBeat
sudo apt-get update && sudo apt-get install filebeat metricbeat
sudo systemctl enable filebeat

sudo chmod -R 777 /var/lib/docker # or we can`t access the logs

FileBeat config:

filebeat.inputs:
  - type: docker
    containers.ids: '*'
# i wiil get logs from two containers, it`s a very big system load to get logs from all of them
# and for Logstash it would be recursivly.  
output.logstash:
  hosts: ["127.0.0.1:5044"]

MetrickBeat config:

Default config with disabled cloud metadata.

# ----------------------------------- logstash----------------------------------
logstash.ylm

---
http.host: "0.0.0.0"
path.config: /usr/share/logstash/pipeline.yml
xpack.monitoring.enabled: false


pipeline.yml

input {
  beats {
    port => 5044
  }

  tcp {
    port => 5000
  }
}

output {
  elasticsearch {
    hosts => "elasticsearch:9200"
  }
}

# ----------------------------------- Kibana----------------------------------

---
server.name: kibana
server.host: 0.0.0.0
elasticsearch.hosts: [ "http://elasticsearch:9200" ]


# ----------------------------------- Elastic----------------------------------

---
cluster.name: "docker-cluster"
network.host: 0.0.0.0
xpack.monitoring.collection.enabled: false
xpack.monitoring.elasticsearch.collection.enabled: false

####################################################################################################

Step 5: Start ELK

docker-compose up

localhost:5601

Set up MetrickBeat. Add index pattern for FileBeat. Add dashboard.

####################################################################################################

Step 6: Grafana

Add Elasticseach host and indexes for MetrickBeat&FileBeat.
Set up dashboard.

####################################################################################################

Step 7:

EXTRA 2.4: Set up filters on the Logstash side (get separate docker_container and docker_image fields from the message field)

output {
  if [container.name] == "*" {
    elasticsearch {
      hosts => ["es-host"]
      index => "logs-X-%{+YYYY.MM.dd}"
    }
  }
  else if [container.image.name] == "*" {
    elasticsearch {
      hosts => "elasticsearch:9200"
      index => "logs-X-%{+YYYY.MM.dd}"
    }
  }
  else {
    elasticsearch {
      hosts => "elasticsearch:9200"
    }
  }
container.name
container.image.name
####################################################################################################
https://discuss.elastic.co/t/filters-in-logstash-for-sending-the-logs-to-elastic-search-index/69343/3

input {...}

filter {
  json {
    source => "message"
    target => "parsedjson"
  }
  mutate {
     add_field => {"somefield" => "%{[parsedjson][fieldkey]}}"}
  }
}

output {
 if [somefield] == "X" {
    elasticsearch {
      hosts => ["es-host"]
      index => "logs-X-%{+YYYY.MM.dd}"
    }
  }
  else if [somefield] == "Y" {
    elasticsearch {
      hosts => ["es-host"]
      index => "logs-Y-%{+YYYY.MM.dd}"
    }
  }
  else {
    elasticsearch {
      hosts => ["es-host"]
      index => "logs-%{+YYYY.MM.dd}"
    }
  }
}



####################################################################################################


```
