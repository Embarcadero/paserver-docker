#!/usr/bin/env bash
set -e

# apt-get update
apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yy install \
    p7zip-full \
    curl \
    build-essential \
    zlib1g-dev \
    libcurl4-gnutls-dev \
    libncurses5 \
    libpython3.10

curl -L -o ./paserver.tar.gz -L \
    "${PA_SERVER_URL}"

tar xvzf paserver.tar.gz
mv PAServer-${PA_SERVER_VERSION}/* .
rm PAServer-${PA_SERVER_VERSION} -r
rm paserver.tar.gz
mv lldb/lib/libpython3.so lldb/lib/libpython3.so_
ln -s /lib/x86_64-linux-gnu/libpython3.10.so.1 lldb/lib/libpython3.so