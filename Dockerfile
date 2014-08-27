# Dockerfile for ZeroTierOne

FROM ubuntu:14.04

MAINTAINER Davide Marquês <nesrait@gmail.com>

RUN apt-get update && apt-get install -y curl

RUN curl -s https://www.zerotier.com/dist/ZeroTierOneInstaller-linux-x64 > ZeroTierOneInstaller-linux-x64.sh && \
    chmod a+x ZeroTierOneInstaller-linux-x64.sh && \
    ./ZeroTierOneInstaller-linux-x64.sh && \
    rm ZeroTierOneInstaller-linux-x64.sh

EXPOSE 9993/udp

CMD ["zerotier-cli info"]

# NOTICE!
# This packaging is still incomplete since the zerotier-one service is still running as a daemon.
# To fix this we need to properly launch it using supervisord.
