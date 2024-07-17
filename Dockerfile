FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG password=embtdocker

ENV PA_SERVER_URL=https://altd.embarcadero.com/releases/studio/23.0/121/1211/LinuxPAServer23.0.tar.gz
ENV PA_SERVER_VOLUME=/paserver
ENV PA_SERVER_VERSION=23.0
ENV PA_SERVER_PASSWORD=$password

VOLUME ["/root/PAServer/scratch-dir"]

COPY install.sh ./install.sh

RUN chmod +x ./install.sh && \
    sync && \
    ./install.sh && \
    rm -f ./install.sh

COPY paserver_docker.sh ./paserver_docker.sh
RUN chmod +x paserver_docker.sh
# PAServer
EXPOSE 64211
ENTRYPOINT ["./paserver_docker.sh"]
