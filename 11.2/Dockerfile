FROM ubuntu:bionic

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

ADD https://altd.embarcadero.com/releases/studio/22.0/112/LinuxPAServer22.0.tar.gz ./paserver.tar.gz

COPY paserver_docker.sh /paserver_docker.sh

RUN tar xvzf paserver.tar.gz

RUN mv PAServer-22.0/* .

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install \
    build-essential \
    libcurl-openssl1.0-dev \
    libcurl3 \
    libgl1-mesa-dev \
    libgtk-3-bin \
    libosmesa-dev \
    libpython3.6 \
    xorg

RUN chmod +x paserver_docker.sh

EXPOSE 64211

CMD /paserver_docker.sh
