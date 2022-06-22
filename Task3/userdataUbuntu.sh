#!/bin/bash
echo "=============================START OF FILE==============================="
apt update -y
apt install -y \
apache2 \
ca-certificates \
curl \
gnupg \
lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update -y
apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-compose-plugin
echo "<html><body bgcolor=white><center><h1><p><font color=red>Hello World</h1></center></body></html>" > /var/www/html/index.html
cat >> ""
cat /etc/os-release >> /var/www/html/index.html
echo "<br><br>" >> /var/www/html/index.html
docker version >> /var/www/html/index.html
systemctl start apache2
systemctl enable apache2
echo "==============================END OF FILE================================"
