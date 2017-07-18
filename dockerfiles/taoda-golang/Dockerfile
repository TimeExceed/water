FROM debian:latest
RUN mkdir /root/golibs
COPY sources.list /etc/apt/
COPY bashrc /root/.bashrc
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y golang git
RUN apt-get clean -y
WORKDIR /opt/golang