FROM ubuntu:20.04

WORKDIR /var/www/html/

ENV TZ=Europe/Kiev
ENV DEVOPS=Anpilogov

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y
RUN apt-get install -y apache2
RUN apt-get install -y nano

CMD echo "<html><body bgcolor=white><center><h1><p><font color=red>Hello World</h1></center></body></html>" > index.html ; echo -e "DEVOPS $DEVOPS" >> index.html ; /usr/sbin/apache2ctl -D FOREGROUND

EXPOSE 80
