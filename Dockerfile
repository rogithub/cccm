FROM debian:latest
RUN mkdir -p /opt/cccm
ARG BINARY_PATH
WORKDIR /opt/cccm
RUN apt-get update && apt-get install -y \
  ca-certificates \
  libgmp-dev libpq-dev build-essential
RUN echo $BINARY_PATH
COPY "$BINARY_PATH" /opt/cccm
CMD ["/opt/cccm/cccm-exe"]
