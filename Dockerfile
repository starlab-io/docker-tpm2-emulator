FROM ubuntu:16.04
MAINTAINER Doug Goldstein <doug@starlab.io>

# bring in dependencies
RUN apt-get update && \
    apt-get --yes --quiet install build-essential git automake autoconf curl \
        libssl-dev pkg-config autoconf-archive libtool libcurl4-openssl-dev && \
    apt-get clean &&  \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/*

# tpm2-emulator
RUN curl -sSfL https://sourceforge.net/projects/ibmswtpm2/files/ibmtpm974.tar.gz/download > ibmtpm974.tar.gz && \
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

RUN ldconfig

# have the tpm2 tools always connect to the socket
ENV TPM2TOOLS_TCTI_NAME=socket

# the TPM emulator listens on ports 2321 and 2322.
EXPOSE 2321
EXPOSE 2322

# default action is to start the TPM emulator with its state cleared
CMD ["tpm_server", "-rm"]
