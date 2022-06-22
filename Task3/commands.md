```
#local
scp -i ../n_virginia.cer ../n_virginia.cer ubuntu@18.206.14.231:~

#Ubuntu
wget https://docs.nginx.com/nginx-instance-manager/scripts/fetch-external-dependencies.sh
chmod +x fetch-external-dependencies.sh
./fetch-external-dependencies.sh centos7
scp -i n_virginia.cer nms-dependencies-centos7.tar.gz ec2-user@172.16.0.12:~
ssh -i n_virginia.cer ec2-user@172.16.0.12

#CentOS
tar -zxvf nms-dependencies-centos7.tar.gz
sudo yum localinstall *.rpm
sudo chmod 777 /usr/share/nginx/html/index.html
echo "<html><body bgcolor=white><center><h1><p><font color=red>Hello World</h1></center></body></html>" > /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl status nginx
exit

#Ubuntu
curl 172.16.0.8
<html><body bgcolor=white><center><h1><p><font color=red>Hello World</h1></center></body></html>
```
