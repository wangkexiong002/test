FROM buildroot/base:latest as BUILDER

ARG BR_VERSION=2018.08.2

RUN wget -qO- --no-check-certificate "https://buildroot.org/downloads/buildroot-${BR_VERSION}.tar.gz" | tar xz
ADD rootfs/config /home/br-user/buildroot-${BR_VERSION}/.config

RUN cd buildroot-${BR_VERSION} \
    && make oldconfig && make --quiet \
    && mkdir -p /home/br-user/rootfs \
    && tar xvf output/images/rootfs.tar -C /home/br-user/rootfs

FROM scratch

COPY --from=BUILDER /home/br-user/rootfs /
