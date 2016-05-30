#!/bin/sh
set -x
docker run -h centos6 -p 192.168.3.129:22:22 -d --name centos6 --restart=always -v /home/alfred/docker/data/centos6:/home/alfred/doc kanalfred/centos6
