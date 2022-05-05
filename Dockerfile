FROM ubuntu:20.04

COPY /configure /usr/src/configure
COPY /configure.ac /usr/src/configure.ac
COPY /include /usr/src/include
COPY /install-sh /usr/src/install-sh
COPY /install_deps /usr/src/install_deps
COPY /lib /usr/src/lib
COPY /makefile.in /usr/src/makefile
COPY /src /usr/src/src/src

ENV EMUDIR=/opt/bizkawk
ENV N64=/opt/n64
ENV PATH $PATH:${N64}/bin:${EMUDIR}

RUN apt-get update && \
    apt-get -y install wget libcg libcggl lsb-release \
    mono-complete libopenal-dev

WORKDIR /usr/src

RUN mkdir -p /opt/bizhawk

RUN wget -q https://github.com/TASEmulators/BizHawk/releases/download/2.8/BizHawk-2.8-linux-x64.tar.gz && \
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

