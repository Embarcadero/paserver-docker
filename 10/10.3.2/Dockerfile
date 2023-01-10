FROM ubuntu:bionic

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

ADD http://altd.embarcadero.com/releases/studio/20.0/PAServer/Release2/LinuxPAServer20.0.tar.gz ./paserver.tar.gz

COPY paserver_docker.sh ./paserver_docker.sh

RUN tar xvzf paserver.tar.gz

RUN mv PAServer-20.0/* .

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yy install xorg libgl1-mesa-dev libosmesa-dev libgtk-3-bin build-essential libcurl3 libcurl-openssl1.0-dev 

RUN chmod +x paserver_docker.sh

EXPOSE 64211
EXPOSE 8082

CMD ./paserver_docker.sh