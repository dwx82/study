```
Step 0: Create a custom container from jenkins/jenkins:lts. Dockerfile attached.

####################################################################################################

Step 1: Spin up a VM (Ubuntu 20.04), and deploy via ansible Jenkins-master docker and jenkins slaves docker on it.

####################################################################################################

Step 2: Unlock master, install Plugins. Nodes and host configured by ansible.

https://plugins.jenkins.io/ssh/
https://plugins.jenkins.io/ssh-steps/
# For Extra 1. Create a pipeline, which will run a docker container from Dockerfile at the additional VM.


https://docs.cloudbees.com/docs/cloudbees-ci/latest/cloud-secure-guide/injecting-secrets
# Pass encrypted variable

####################################################################################################

Step 3: Add nodes via web interface. Host agent labeled "master", slaves - "slaves slaveX" (X - slaves number)

####################################################################################################

Step 4: date #Without comments

####################################################################################################

Step 5: Jenkinsfile1

pipeline {
   agent {label 'master'}
   stages {
       stage('first step') {
           steps {
               sh '''
                  docker ps -a
               '''  
           }
       }
   }
}

####################################################################################################

Step 6: Jenkinsfile2

pipeline {
    agent { label 'slaves'}
    stages {
        stage('github') {
            steps {
                sh '''
                  docker image build -t task66image https://github.com/dwx82/study.git#master:Task4
                  docker images
                '''  
            }
        }
    }
}

####################################################################################################

Step 7: Encrypt variable and pass it to the docker on the remote VM
https://docs.cloudbees.com/docs/cloudbees-ci/latest/cloud-secure-guide/injecting-secrets

Build with encrypted credentials and variable. Password pass as expected.



                                  "" and '' ARE VERY IMPORTANT.



withCredentials([usernamePassword(credentialsId: 'for-vm', passwordVariable: 'pass', usernameVariable: 'user'), string(credentialsId: 'PASSWORD', variable: 'pwd')]) {
    // some block
    node {
  def remote = [:]
  remote.name = 'remotevm'
  remote.host = '172.16.1.139'
  remote.user = user
  remote.password = pass
  remote.allowAnyHosts = true
  stage('Remote SSH') {
    sshCommand remote: remote, command: 'docker build -t vartest .', failOnError:'false'
    sshCommand remote: remote, command: 'docker run --rm -e PASSWORD=$pwd vartest > 1.txt'
  }
}
}

####################################################################################################

Step 8: To configure integration between GitHub and Jenkins I will need AWS EC2 instance running jenkins.

Create token in jenkins -> add to git, set application/json.
In jenkins enable matrix based security -> Enable hooks in the joob -> add ssh credentials for github.
....

####################################################################################################

 Step 9: Deploy a local docker registry, upload a docker image there, download img from your local docker registry and run the container.
https://docs.docker.com/registry/deploying/

Run a local registry

docker run -d -p 5000:5000 --restart=always --name registry registry:2

The registry is now ready to use.

Pull an image from Docker Hub. Tag the image as localhost:5000/my-image. This creates an additional tag for the existing image. When the first part of the tag is a hostname and port, Docker interprets this as the location of a registry, when pushing.
Push the image to the local registry running at localhost:5000

docker pull ubuntu:16.04
docker tag ubuntu:16.04 localhost:5000/my-ubuntu

Remove the locally-cached ubuntu:16.04 and localhost:5000/my-ubuntu images, so that you can test pulling the image from your registry. This does not remove the localhost:5000/my-ubuntu image from your registry. Pull the localhost:5000/my-ubuntu image from your local registry.


docker rmi ubuntu:16.04 localhost:5000/my-ubuntu
docker pull localhost:5000/my-ubuntu
docker run -d localhost:5000/my-ubuntu


VERY, VERY strange task - ctrl-c + ctrl-v from docs and extra simple for extra.


####################################################################################################

Clouds -

Log in to the server and open the docker service file /lib/systemd/system/docker.service.
Search for ExecStart and replace that line with the following.

ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock

Reload and restart docker service.

sudo systemctl daemon-reload
sudo service docker restart

Validate API by executing the following curl commands. Replace 54.221.134.7 with your host IP.

curl http://localhost:4243/version



https://devopscube.com/docker-containers-as-build-slaves-jenkins/

Jenkins Agent Docker Image

docker pull bibinwilson/jenkins-slave
sudo docker run -d --name=slave1 -p 1122:22 -v /usr/bin/docker:/usr/bin/docker  -v /var/run/docker.sock:/var/run/docker.sock bibinwilson/jenkins-slave

Note: The default ssh username is jenkins and the password is also jenkins as per the given Dockerfile. You will have to use these credentials in the below configuration.


sudo chmod 666 /var/run/docker.sock or sudo chown $USER /var/run/docker.sock or sudo chown root:docker /var/run/docker.sock

```
