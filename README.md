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

Let's start off by checking if zerotier image is properly working.

For this we will launch the container in the foreground passing in the docker "--rm" flag to clean things up when we kill the container, the "--privileged" flag to provide access to the Tun module to ZeroTier.
```bash
docker run --rm --privileged=true nesrait/zerotier
```

The output should show that the zerotier-one service is running as expected but it's not very clear how to use it.
We could have installed an SSH server inside the container to enable entering the running container and interact with ZeroTier but that would create a more bloated image and an extra attack surface. Check out the ["Docker+SSH is Bad" topic](https://news.ycombinator.com/item?id=7950326).

Instead of connecting to the running container via SSH we will use [nsinit](http://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/). To install it follow [these instructions](https://registry.hub.docker.com/u/yungsang/nsinit/).

Kill off the container running in the foreground and let's now run it as a daemon by passing the "-d" flag:
```bash
ZTCONTAINERID=`docker run -d --privileged=true nesrait/zerotier`
```

We store the container id on the ZTCONTAINERID environment variable because we'll need it ahead while using docker-nsinit.

With the container running go ahead and join the [Planet Earth](https://www.zerotier.com/earth.html) public network:
```bash
docker-nsinit $ZTCONTAINERID zerotier-cli join 8056c2e21c000001
```

After a few seconds a new network adapter should show up:
```bash
docker-nsinit $ZTCONTAINERID ifconfig zt0
```

Now check out the earth homepage!
```bash
docker-nsinit $ZTCONTAINERID curl http://earth.zerotier.net/
```

Note: if you're joining a private network you need to visit your [ZeroTier admin backend](https://www.zerotier.com/admin.html) and Authorize the new nodes. Only then will they receive an IP address and join the network.


Next Steps
----------

1. Create a wrapper script that checks if the ZTNETWORK environment variable is set (when the container is launched) and joins that network immediately.
2. ?
3. Profit


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
