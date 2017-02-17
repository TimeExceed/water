FROM debian
COPY sources.list /etc/apt/
RUN apt-get -y update
RUN apt-get -y install scons aptitude
RUN apt-get clean
