# Forked from subspacecloud/subspace ![Docker](https://github.com/lsgrep/subspace/workflows/Docker/badge.svg)

## Modifications

- Optimized build process & Everything works
- DNS defaults to `8.8.8.8`, `2001:4860:4860::8888`

## Setup

### Preparations

1. Containers share the same network namespace with the host, make sure following ports are open

- 80/tcp
- 443/tcp
- 53/udp
- 51820/udp

2. Enable port forwarding on the host

### HTTP version behind proxy

```
version: "3.3"
services:
  subspace:
    image: lsgrep/subspace:latest
    container_name: subspace
    privileged: true
    volumes:
      - /opt/docker/subspace:/data
      - /lib/modules:/lib/modules
    restart: unless-stopped
    environment:
      - SUBSPACE_HTTP_HOST=YOUR_DOMAIN
      - SUBSPACE_LETSENCRYPT=false
      - SUBSPACE_HTTP_INSECURE=true
      - SUBSPACE_HTTP_ADDR=":8889"
      - SUBSPACE_NAMESERVER=8.8.8.8
      - SUBSPACE_LISTENPORT=51820
      - SUBSPACE_IPV4_POOL=10.99.97.0/24
      - SUBSPACE_IPV6_POOL=fd00::10:97:0/64
      - SUBSPACE_IPV4_GW=10.99.97.1
      - SUBSPACE_IPV6_GW=fd00::10:97:1
      - SUBSPACE_IPV6_NAT_ENABLED=0
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    network_mode: "host"
```

### HTTPS version with LetsEncrypt certificates

```
version: "3.3"
services:
  subspace:
    image: lsgrep/subspace:latest
    container_name: subspace
    privileged:  true
    volumes:
      - /opt/docker/subspace:/data
      - /lib/modules:/lib/modules
    restart: unless-stopped
    environment:
      - SUBSPACE_HTTP_HOST=YOUR_DOMAIN
      - SUBSPACE_LETSENCRYPT=true
      - SUBSPACE_HTTP_INSECURE=false
      - SUBSPACE_HTTP_ADDR=":80"
      - SUBSPACE_NAMESERVER=8.8.8.8
      - SUBSPACE_LISTENPORT=51820
      - SUBSPACE_IPV4_POOL=10.99.97.0/24
      - SUBSPACE_IPV6_POOL=fd00::10:97:0/64
      - SUBSPACE_IPV4_GW=10.99.97.1
      - SUBSPACE_IPV6_GW=fd00::10:97:1
      - SUBSPACE_IPV6_NAT_ENABLED=0
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    network_mode: "host"
```
