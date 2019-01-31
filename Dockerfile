FROM debian:stretch-slim
RUN mkdir -p /opt/cccm
WORKDIR /opt/cccm
RUN apt-get update && apt-get install -y \
  ca-certificates \
  libgmp-dev libpq-dev build-essential
COPY ./.stack-work/dist/x86_64-linux/Cabal-2.4.0.1/build/cccm-exe/cccm-exe /opt/cccm
CMD ["/opt/cccm/cccm-exe"]
