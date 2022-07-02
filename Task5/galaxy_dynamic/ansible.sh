#!/bin/bash
echo "=============================START OF FILE==============================="
amazon-linux-extras enable ansible2 python3.8
yum clean metadata
yum install -y python3.8
yum install -y ansible
yum install -y python3-pip
yum install -y python-boto3
echo "==============================END OF FILE================================"
