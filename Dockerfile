FROM ubuntu:16.04
MAINTAINER Doug Goldstein <doug@starlab.io>

# bring in dependencies
RUN apt-get update && \
    apt-get --yes --quiet install build-essential git automake autoconf wget \
        libssl-dev pkg-config autoconf-archive libtool libcurl4-openssl-dev && \
    apt-get clean &&  \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/*

# tpm2-emulator
RUN wget -O ibmtpm974.tar.gz https://sourceforge.net/projects/ibmswtpm2/files/ibmtpm974.tar.gz/download && \
    mkdir ibmtpm && \
    cd ibmtpm && \
    tar -zxf ../ibmtpm974.tar.gz && \
    cd src && \
    make && \
    mv tpm_server /usr/local/bin/ && \
    cd && \
    rm -rf ibmtpm ibmtpm974.tar.gz

# tpm2-tss
RUN git clone https://github.com/01org/tpm2-tss.git && \
    cd tpm2-tss && \
    ./bootstrap && \
    ./configure && \
    make && \
    make install && \
    cd && \
    rm -rf tpm2-tss

# tpm2-tools
RUN git clone https://github.com/01org/tpm2-tools.git && \
    cd tpm2-tools && \
    ./bootstrap && \
    ./configure --disable-hardening --with-tcti-socket --with-tcti-device && \
    make && \
    make install && \
    cd && \
    rm -rf tpm2-tools

# have the tpm2 tools always connect to the socket
ENV TPM2TOOLS_TCTI_NAME=socket
