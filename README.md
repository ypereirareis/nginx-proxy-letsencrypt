# Nginx reverse Proxy Lets Encrypt

Docker configuration to use letsencrypt automatically with jwilder nginx reverse proxy

## TL;DR

A configuration to generate and renew your certificates automatically with ets Encrypt and Jwilder nginx reverse proxy.

You need **docker 1.12+** and **docker-compose 1.8+ (v2)**

* Reverse proxy container name => **michel**
* Reverse proxy network name => **nginx-proxy**
* Starting the stack => `make install`

The reverse proxy is connected to the default bridge network thanks to the Makefile.

```
docker network connect bridge michel || true
```

## Start 

```
git clone git@github.com:ypereirareis/nginx-proxy-letsencrypt.git
cd nginx-proxy-letsencrypt
make install
```

## Docker compose configuration

```
version: '2'
services:
  michel-nginx:
    image: jwilder/nginx-proxy
    container_name: michel
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "/var/run/docker.sock:/tmp/docker.sock:ro"
      - "/etc/nginx/conf.d"
      - "/etc/nginx/vhost.d"
      - "/usr/share/nginx/html"
      - "./conf/proxy.conf:/etc/nginx/conf.d/my_proxy.conf:ro"
#      - "PATH_TO_PASSWORDS:/etc/nginx/htpasswd"
#      - "PATH_TO_CERTS/certs:/etc/nginx/certs:ro"
#      - "PATH_TO_CUSTOM_CONFIG:/etc/nginx/conf.d/custom.conf:ro"
    networks:
      - nginx-proxy

  michel-letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    restart: always
    container_name: michel-letsencrypt
    volumes_from:
      - michel-nginx
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "PATH_TO_CERTS/certs:/etc/nginx/certs:rw"
    networks:
      - nginx-proxy
#    environment:
#     - ACME_CA_URI=https://acme-staging.api.letsencrypt.org/directory

networks:
  nginx-proxy:
    external:
      name: nginx-proxy

```

## How it works

Configuration based on those repositories:

* [https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
* [https://github.com/fatk/docker-letsencrypt-nginx-proxy-companion-examples](https://github.com/fatk/docker-letsencrypt-nginx-proxy-companion-examples)

I advise you to read the documentation of those repositories...
and [this section in particular](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion#lets-encrypt).

### Volumes

**/etc/nginx/conf.d**

Nginx configuration files are generated into this repository by the reverse proxy.

**/etc/nginx/vhost.d**

The "letsencrypts" docker container generates temporary virtual hosts to allow [https://letsencrypt.org/](https://letsencrypt.org/) to verify the domain name.

**/usr/share/nginx/html**

The "letsencrypts" docker container generates a file into this volume.
The file is accessed by [https://letsencrypt.org/](https://letsencrypt.org/) during the domain validation process.

**PATH_TO_CERTS/certs:/etc/nginx/certs:ro** 

The path where Letsencrypt certificates are going to be generated.
The certs generation can be long.... please wait before killing everything !

**PATH_TO_PASSWORDS:/etc/nginx/htpasswd**  
**PATH_TO_CUSTOM_CONFIG:/etc/nginx/conf.d/custom.conf:ro**  

Those two volumes are here to add custom configuration, see [https://github.com/jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)

## LICENSE

The MIT License (MIT)

Copyright (c) 2017 Yannick Pereira-Reis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
