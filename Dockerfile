FROM ubuntu:20.04

COPY /include /usr/src
COPY /lib /usr/src
COPY /src /usr/src
COPY /configure /usr/src
COPY /configure.ac /usr/src
COPY /install-sh /usr/src
COPY /install_deps /usr/src
COPY /makefile.in /usr/src

ENV EMUDIR=/opt/bizkawk
ENV N64=/opt/n64
ENV PATH $PATH:${N64}/bin:${EMUDIR}

RUN apt-get update && \
    apt-get -y install wget libcg libcggl lsb-release \
    mono-complete libopenal-dev

WORKDIR /usr/src

RUN mkdir -p /opt/bizhawk

RUN wget https://github.com/TASEmulators/BizHawk/releases/download/2.8/BizHawk-2.8-linux-x64.tar.gz && \
    tar -xf BizHawk-2.8-linux-x64.tar.gz -C /opt/bizhawk && \
    rm -rf BizHawk-2.8-linux-x64.tar.gz

RUN ./install_deps

RUN ./configure --prefix=/opt/n64 && \
    make install-toolchain && \
    make && make install && \
    make install-sys && \
    make install-local-exec

FROM ubuntu:20.4

ENV EMUDIR=/opt/bizkawk
ENV N64=/opt/n64
ENV PATH $PATH:${N64}/bin:${EMUDIR}

COPY --from=0 ${N64} ${N64}
COPY --from=0 ${EMUDIR} ${EMUDIR}
