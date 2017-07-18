FROM debian:8
COPY sources.list /etc/apt/
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install scons
RUN apt-get clean
