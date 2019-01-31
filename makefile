build:
	@echo "[building project]"
	stack build
	@echo "[deploying to docker]"
	sudo docker build -t "cccm:latest" .
	sudo docker run --name cccm -d -p:80:80 cccm:latest
	sudo docker stop cccm
	sudo docker commit -m "adding cccm" -a "Rodrigo Debian" cccm rodocker/cccm:latest
	sudo docker login
	sudo docker push rodocker/cccm
	sudo docker rm cccm
	sudo docker rmi rodocker/cccm
	sudo docker rmi cccm
