#!/bin/bash
echo "=============================START OF FILE==============================="
amazon-linux-extras enable ansible2 python3.8
yum clean metadata
yum install -y python3.8
yum install -y ansible
echo "==============================END OF FILE================================"
