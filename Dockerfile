FROM starlabio/ubuntu-base:1.6
MAINTAINER Doug Goldstein <doug@starlab.io>

# Install behave and hamcrest for testing
RUN pip install behave pyhamcrest requests pexpect

# bring in dependencies
RUN apt-get update && \
    apt-get --yes --quiet install build-essential git automake autoconf curl \
        pkg-config autoconf-archive libtool libcurl4-openssl-dev libgmp-dev \
        libssl-dev cmake trousers tpm-tools alien && \
    apt-get clean &&  \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/*

# have trousers always connect to the tpm-emulator
ENV TCSD_USE_TCP_DEVICE=1

# the trousers listens on ports 2412
EXPOSE 2412

# tpm2-emulator
ADD ibmtpm974.tar.gz ibmtpm
RUN cd ibmtpm && \
    cd src && \
    make && \
    mv tpm_server /usr/local/bin/ && \
    cd && \
    rm -rf ibmtpm ibmtpm974.tar.gz

# tpm2-tss
ADD tpm2-tss-1.2.0.tar.gz tpm2-tss-1.2.0
RUN cd tpm2-tss-1.2.0/tpm2-tss-1.2.0 && \
    ./configure --prefix=/usr && \
    CXXFLAGS="-Wno-error" make && \
    make install && \
    cd && \
    rm -rf tpm2-tss-1.2.0 && \
    ldconfig

# tpm2-tools
ADD tpm2-tools-2.1.0.tar.gz tpm2-tools-2.1.0
RUN cd tpm2-tools-2.1.0/tpm2-tools-2.1.0 && \
    ./bootstrap && \
    ./configure --prefix=/usr --disable-hardening --with-tcti-socket --with-tcti-device && \
    make && \
    make install && \
    cd && \
    rm -rf tpm2-tools-2.1.0 && \
    ldconfig

# have the tpm2 tools always connect to the socket
ENV TPM2TOOLS_TCTI_NAME=socket

# the TPM2 emulator listens on ports 2321 and 2322.
EXPOSE 2321
EXPOSE 2322
