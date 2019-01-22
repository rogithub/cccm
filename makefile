## Build binary and docker images
## https://www.fpcomplete.com/blog/2017/12/building-haskell-apps-with-docker

build:
	@stack build
	@sudo docker-compose build
