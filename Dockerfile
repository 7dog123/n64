FROM ubuntu:20.04

COPY . /usr/src/

ENV EMUDIR=/opt/bizkawk
ENV N64=/opt/n64
ENV PATH $PATH:${N64}/bin:${EMUDIR}

RUN apt-get update && \
    apt-get -y install wget libcg libcggl lsb-release \
    mono-complete libopenal-dev wget tar make diffutils \
    texinfo gcc g++ lua5.3 libusb-1.0

WORKDIR /usr/src

RUN mkdir -p /opt/bizhawk/Lua

RUN wget -q https://github.com/TASEmulators/BizHawk/releases/download/2.8/BizHawk-2.8-linux-x64.tar.gz && \
    tar -xf BizHawk-2.8-linux-x64.tar.gz -C /opt/bizhawk && \
    rm -rf BizHawk-2.8-linux-x64.tar.gz

RUN ./install_deps

RUN ./configure --quiet --prefix=/opt/n64 && \
    make --quiet install-toolchain && \
    make --quier && make --quier install && \
    make --quiet install-sys && \
    make --quiet install-local-exec

FROM ubuntu:20.4

ENV EMUDIR=/opt/bizkawk
ENV N64=/opt/n64
ENV PATH $PATH:${N64}/bin:${EMUDIR}

COPY --from=0 ${N64} ${N64}
COPY --from=0 ${EMUDIR} ${EMUDIR}

