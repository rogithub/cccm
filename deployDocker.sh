#!/bin/bash
docker build -t "cccm:latest" .
docker run --name cccm -d -p:8000:8000 cccm:latest
docker commit -m "adding cccm" -a "Rodrigo Debian" cccm rodocker/cccm:latest
docker login
docker push rodocker/cccm
