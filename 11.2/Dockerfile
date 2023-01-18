FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG password=embtdocker

ENV PA_SERVER_PASSWORD=$password

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install \
    build-essential \
    libcurl4-openssl-dev \
    libcurl3-gnutls \
    libgl1-mesa-dev \
    libgtk-3-bin \
    libosmesa-dev \
    libpython3.10 \
    xorg

### Install PAServer
ADD https://altd.embarcadero.com/releases/studio/22.0/112/LinuxPAServer22.0.tar.gz ./paserver.tar.gz

RUN tar xvzf paserver.tar.gz
RUN mv PAServer-22.0/* .

# link to installed libpython3.10
RUN mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
RUN ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so

COPY paserver_docker.sh ./paserver_docker.sh
RUN chmod +x paserver_docker.sh

#=====CLEAN UP==========
RUN rm PAServer-22.0 -r
RUN rm paserver.tar.gz
#======END CLEAN UP=====

# PAServer
EXPOSE 64211
# broadwayd
EXPOSE 8082

CMD ./paserver_docker.sh
