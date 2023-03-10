FROM ubuntu:jammy
LABEL version="0.1"
LABEL description="Webmin over Ubuntu 22.04 basic"
LABEL name="webmin"

# Usuario 'root'
USER root

# Se instala dependencias
RUN apt-get update -qq -y && \
    apt-get upgrade -y && \
    apt-get install -y \
       wget \
       curl \
       apt-transport-https \
       lsb-release \
       ca-certificates \
       gnupg2 \
       software-properties-common \
       tzdata \
       cron

# Se configura timezone
ENV TZ=America/Bogota
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \ 
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Se crea contraseña usuario 'root'
RUN echo root:12345678 | chpasswd

# Se agrega repositorio APT de Webmin
RUN echo "deb https://download.webmin.com/download/repository sarge contrib" >>  /etc/apt/sources.list
RUN wget https://download.webmin.com/jcameron-key.asc && \
    cat jcameron-key.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/jcameron-key.gpg

# Se instala Webmin
RUN apt-get update && \
    apt-get install webmin -y && \ 
    apt-get clean

EXPOSE 10000

# Se crea scipt entrypoint.sh para iniciar el servicio de Webmin
WORKDIR /root
RUN echo echo "#! /bin/bash" > entrypoint.sh && \
    echo "systemctl enable cron && service webmin start && tail -f /dev/null" >> entrypoint.sh && \
    # echo "service webmin start && tail -f /dev/null" >> entrypoint.sh && \
    chmod 755 entrypoint.sh
CMD /root/entrypoint.sh








  
