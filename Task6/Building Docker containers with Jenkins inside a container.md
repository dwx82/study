
```
https://tutorials.releaseworksacademy.com/learn/the-simple-way-to-run-docker-in-docker-for-ci


############# OLD VERSION ############
Deprecated. It works, but to big outputfile.

docker run -d -p 8080:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name megacontainer \
  jenkins/jenkins:lts

  docker exec -it -u root megacontainer bash

  apt-get update && \
apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce && \
usermod -aG docker jenkins ; apt-get install -y ssh && service ssh start

adduser sshuser
usermod -aG sudo sshuser

sshpassword
```
