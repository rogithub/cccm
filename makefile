## Build binary and docker images
## https://www.fpcomplete.com/blog/2017/12/building-haskell-apps-with-docker

## push to docker hub
## https://www.techrepublic.com/article/how-to-create-a-docker-image-and-push-it-to-docker-hub/
## $ sudo docker commit -m "adding cccm" -a "Rodrigo Debian" cccm rodocker/cccm:latest
## $ sudo docker login
## $ sudo docker push rodocker/cccm

build:
	@stack build
	@sudo docker build -t "cccm:latest" .
	@sudo docker run --name cccm -d -p:8000:8000 cccm:latest
