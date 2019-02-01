build:
	@echo "[building project]"
	stack build
	@echo "[deploying to docker]"
	docker build -t "cccm:latest" .
	docker run --name cccm -d -p:80:80 cccm:latest
	docker stop cccm
	docker commit -m "adding cccm" -a "Rodrigo Debian" cccm rodocker/cccm:latest
	docker login
	docker push rodocker/cccm
	docker rm cccm
	docker rmi rodocker/cccm
	docker rmi cccm
