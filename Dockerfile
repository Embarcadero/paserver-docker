FROM ubuntu:jammy
# jammy is the code name of 22.04 LTS

ARG password=securepass

ENV PA_SERVER_PASSWORD=$password
ENV PA_SERVER_URL=https://altd.embarcadero.com/releases/studio/23.0/121/1211/LinuxPAServer23.0.tar.gz
ENV PA_SERVER_VERSION=23.0

### Copy the PAServer runner script
COPY paserver_docker.sh ./paserver_docker.sh

### Run all commands in a single layer - this might affect the final image size
RUN apt-get update && apt-get -y autoremove --purge && apt-get -y clean && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install \
    joe \
    p7zip-full \
    curl \
    openssh-server \
    build-essential \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libncurses5 \
    libpython3.10 \
    && rm -rf /var/lib/apt/lists/* \
    ### Download PAServer
    && wget -O ./paserver.tar.gz "${PA_SERVER_URL}" \
    ### Extract PAServer to the right folder and remove the compressed file
    && tar xvzf paserver.tar.gz \
    && mv PAServer-${PA_SERVER_VERSION}/* . \
    && rm PAServer-${PA_SERVER_VERSION} -r \
    && rm paserver.tar.gz \
    ### Creates the symlink to the Python interpreter in the PAServer required location
    && mv lldb/lib/libpython3.so lldb/lib/libpython3.so_ \
    && ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so \
    ### Add executes permission to run paserver_docker.sh later on
    && chmod +x paserver_docker.sh

### Expose PAServer`s default port
EXPOSE 64211

### Get ready to bind to PAServer`s default scratch dir
VOLUME ["/root/PAServer/scratch-dir"]

### Executes PAServer runner script
ENTRYPOINT ["./paserver_docker.sh"]
