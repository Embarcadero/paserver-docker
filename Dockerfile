# Build Stage
FROM ubuntu:jammy AS builder

ARG password=securepass

ENV PA_SERVER_PASSWORD=$password
ENV PA_SERVER_URL=https://altd.embarcadero.com/releases/studio/23.0/123/LinuxPAServer23.0.tar.gz
ENV PA_SERVER_VERSION=23.0

# Install build dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yy --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and extract PAServer
RUN curl -L "${PA_SERVER_URL}" -k -o ./paserver.tar.gz \
    && tar xvzf paserver.tar.gz \
    && mkdir /paserver \
    && mv PAServer-${PA_SERVER_VERSION}/* /paserver \
    && rm -rf PAServer-${PA_SERVER_VERSION} paserver.tar.gz

# Runtime Stage
FROM ubuntu:jammy

# Install runtime dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yy --no-install-recommends \
    joe \
    curl \
    build-essential \
    p7zip-full \
    openssh-server \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libncurses5 \
    libpython3.10 \
    && rm -rf /var/lib/apt/lists/*

# Copy PAServer and the runner script from the builder stage
COPY --from=builder /paserver /paserver
COPY paserver_docker.sh /paserver/paserver_docker.sh

# Set work directory
WORKDIR /paserver

# Creates the symlink to the Python interpreter in the PAServer required location and grant execution permission to the runner script
RUN mv lldb/lib/libpython3.so lldb/lib/libpython3.so_ \
    && ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so \
    && chmod +x ./paserver_docker.sh

# Expose PAServer's default port
EXPOSE 64211

# Get ready to bind to PAServer's default scratch dir
VOLUME ["/root/PAServer/scratch-dir"]

# Executes PAServer runner script
ENTRYPOINT ["./paserver_docker.sh"]
