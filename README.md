Docker + ZeroTier
=================

This github project explores how [ZeroTier](https://github.com/zerotier/ZeroTierOne) can be used to simplify the communication with/across Docker containers.

Benefits from ZeroTier to Docker:

	- virtual routing between your cloud and on-premises infrastructure
	- service discovery mechanisms will all work including the ones relying on multicast/broadcast

Benefits from Docker to ZeroTier:

	- connect to open networks without compromising your host (a.k.a. Network Condom)



Running
-------

ZeroTier needs access to the Tun module hence the --privileged option and UDP port mapping:
docker run -it --rm --privileged=true -p 9993/udp nesrait/zerotier bash

\# Join the DockerLand public network
$ zerotier-cli join 8056c2e21ce1f49e
$ sudo service zerotier-one start
$ sudo service zerotier-one start
$ zerotier-cli join 8056c2e21ce1f49e
$ ifconfig zt0



Issues
------

1. after joining no new network interface is appearing as expected:

> An interface called 'zt0' should appear and should get an IP address in
> the 28.0.0.0/7 range (28.* or 29.*) within a few seconds or so. Then try
> pinging earth.zerotier.net or navigating to http://earth.zerotier.net/ in
> a web browser.

This is related with Linux Gotcha #1:
> If you cannot join networks, check to make sure the tun kernel module
> is available or tun/tap support is compiled into the kernel.

Resources on "TUN/TAP device not available inside docker container"

  - [Create tun device within a container](https://groups.google.com/forum/#!topic/docker-user/2jFeDGJj36E)
  - [DOCKER + JOYENT + OPENVPN = BLISS](http://blog.docker.com/2013/09/docker-joyent-openvpn-bliss/)
  - [Installing new gentoo kernel in docker container](http://stackoverflow.com/questions/25484090/installing-new-gentoo-kernel-in-docker-container)
