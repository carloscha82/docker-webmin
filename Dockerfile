FROM ubuntu:jammy
LABEL version="0.1"
LABEL description="Webmin over Ubuntu 22.04 basic"
LABEL name="webmin"
USER root

RUN apt-get update && apt-get install wget gpg apt-transport-https -y
RUN echo "deb https://download.webmin.com/download/repository sarge contrib" >>  /etc/apt/sources.list
RUN cd /root && \
    wget https://download.webmin.com/jcameron-key.asc && \
    cat jcameron-key.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/jcameron-key.gpg
RUN echo root:12345678 | chpasswd
RUN apt-get update && \
    apt-get install webmin -y

EXPOSE 10000

WORKDIR /root
RUN echo echo "#! /bin/bash" > entrypoint.sh && \
    echo "service webmin start" >> entrypoint.sh && \
    chmod 755 entrypoint.sh

CMD /root/entrypoint.sh








  
