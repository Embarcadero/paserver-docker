# Build Stage
FROM ubuntu:jammy AS builder

ARG PA_SERVER_SOURCE=remote
ARG PA_SERVER_URL=https://altd.embarcadero.com/releases/studio/37.0/132/LinuxPAServer37.0.tar.gz
ARG PA_SERVER_TARBALL=LinuxPAServer37.0.tar.gz

# Install build dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yy --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY bin/ /tmp/bin/

# Download or copy and extract PAServer
RUN mkdir /paserver \
    && if [ "$PA_SERVER_SOURCE" = "local" ]; then \
         cp "/tmp/bin/${PA_SERVER_TARBALL}" paserver.tar.gz; \
       else \
         curl -fL "${PA_SERVER_URL}" -o paserver.tar.gz; \
       fi \
    && tar xzf paserver.tar.gz --strip-components=1 -C /paserver \
    && rm -rf paserver.tar.gz /tmp/bin

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

# Default password. Override at runtime with -e PA_SERVER_PASSWORD=...
ENV PA_SERVER_PASSWORD=securepass

# Set work directory
WORKDIR /paserver

# Creates the symlink to the Python interpreter in the PAServer required location and grant execution permission to the runner script
RUN mv lldb/lib/libpython3.so lldb/lib/libpython3.so_ \
    && ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so \
    && chmod +x ./paserver_docker.sh

# Expose PAServer's default port
EXPOSE 64211

# Verify PAServer is accepting connections on its default port
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD bash -c 'echo > /dev/tcp/127.0.0.1/64211' || exit 1

# Get ready to bind to PAServer's default scratch dir
VOLUME ["/root/PAServer/scratch-dir"]

# Executes PAServer runner script
ENTRYPOINT ["./paserver_docker.sh"]
