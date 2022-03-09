FROM buildroot/base:latest as BUILDER
ARG BR_VERSION=2021.02.10
RUN wget -qO- --no-check-certificate "https://buildroot.org/downloads/buildroot-${BR_VERSION}.tar.gz" | tar xz
ADD rootfs/config /home/br-user/buildroot-${BR_VERSION}/.config
RUN cd buildroot-${BR_VERSION} \
    && make oldconfig && make --quiet \
    && mkdir -p /home/br-user/rootfs \
    && tar xvf output/images/rootfs.tar -C /home/br-user/rootfs

FROM alpine:3.15 as TRANS
COPY --from=BUILDER /home/br-user/rootfs /home
RUN chown root:root /home -R

FROM scratch
COPY --from=TRANS /home /
CMD ["/usr/bin/python"]
