FROM alpine:3.16

ARG MXE_TAG=build-2022-04-09

RUN apk add --no-cache autoconf automake bash binutils bison bzip2 flex g++ gdk-pixbuf \
    gettext git gperf intltool libtool linux-headers lzip make openssl openssl-dev \
    p7zip patch perl python3 py3-mako ruby unzip wget xz zlib

RUN ln -fs /usr/bin/python3 /usr/bin/python \
    && git clone https://github.com/mxe/mxe.git /opt/mxe \
    && cd /opt/mxe && git checkout ${MXE_TAG} \
    && make MXE_USE_CCACHE= \
            MXE_TARGETS='x86_64-w64-mingw32.static i686-w64-mingw32.static x86_64-w64-mingw32.shared i686-w64-mingw32.shared' \
            JOBS=$(grep "core id" /proc/cpuinfo | sort -u | wc -l) \
            cc cmake llvm \
    && rm -rf .git .ccache pkg log

ENV PATH="/opt/mxe/usr/bin:${PATH}"
