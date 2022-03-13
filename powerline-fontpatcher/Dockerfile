FROM ubuntu:bionic
LABEL maintainer wangkexiong

COPY entrypoint/fontpatcher.sh /root/fontpatcher.sh

RUN apt-get update -y && \
    apt-get install -y python-fontforge git dos2unix && \
    dos2unix /root/fontpatcher.sh && chmod +x /root/fontpatcher.sh && \
    git clone https://github.com/powerline/fontpatcher /root/fontpatcher && \
    rm -rf /root/fontpatcher/.git /root/fontpatcher/.gitattributes /root/fontpatcher/.gitignore && \
    apt-get remove git dos2unix -y && apt-get autoremove -y && \
    apt-get purge -y && \
    rm -rf /var/cache/* /var/log/* && \
    rm -rf /tmp/*

VOLUME [ "/working" ]

ENTRYPOINT [ "/root/fontpatcher.sh" ]
