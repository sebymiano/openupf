FROM ubuntu:20.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y pciutils apt-utils \
     nano \
	 iputils-ping \
	 tcpdump \
	 net-tools \
     tcpdump \
	 ethtool \
	 net-tools \
	 tcpreplay \
	 libisal-dev \
	 libnl-3-dev \
	 libreadline-dev libedit-dev \
	 gcc automake autoconf libtool make \
	 libglib2.0-dev libstdc++-10-dev libevent-dev \
	 iproute2 numactl gdb libnuma-dev \
	 libgnutls28-dev \
	 libmicrohttpd-dev \
	 libjansson-dev \
	 libsystemd-dev \
	 libcurlpp-dev \
	 sysstat 

WORKDIR /opt/upf