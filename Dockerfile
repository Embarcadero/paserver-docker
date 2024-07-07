FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install \
    joe \
    wget \
    p7zip-full \
    curl \
    openssh-server \
    build-essential \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libncurses5 \
    libpython3.10

### Install PAServer
ADD https://altd.embarcadero.com/releases/studio/23.0/121/1211/LinuxPAServer23.0.tar.gz ./paserver.tar.gz

RUN tar xvzf paserver.tar.gz
RUN mv PAServer-23.0/* .
RUN rm PAServer-23.0 -r
RUN rm paserver.tar.gz

# link to installed libpython3.10
RUN mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
RUN ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so

COPY paserver_docker.sh ./paserver_docker.sh
RUN chmod +x paserver_docker.sh

# PAServer
EXPOSE 64211

CMD ./paserver_docker.sh
