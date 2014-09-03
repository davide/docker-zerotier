# Dockerfile for ZeroTierOne

FROM ubuntu:14.04

MAINTAINER Davide Marquês <nesrait@gmail.com>

RUN apt-get update && apt-get install -y curl

RUN apt-get -y install supervisor && \
    mkdir -p /var/log/supervisor

RUN curl -s https://www.zerotier.com/dist/ZeroTierOneInstaller-linux-x64 > ZeroTierOneInstaller-linux-x64.sh && \
    chmod a+x ZeroTierOneInstaller-linux-x64.sh && \
    ./ZeroTierOneInstaller-linux-x64.sh && \
    rm ZeroTierOneInstaller-linux-x64.sh && \
    sudo service zerotier-one stop && \
    rm /var/lib/zerotier-one/zerotier-one.pid && \
    echo "manual" >> /etc/init/zerotier-one.override && \
    rm /var/lib/zerotier-one/identity.secret && \
    rm /var/lib/zerotier-one/identity.public

# use supervisord to start zerotier
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9993/udp

# Default command when starting the container
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
