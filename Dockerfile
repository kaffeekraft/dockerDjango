# Django
#
# VERSION 1.0

# a light weight linux distro
FROM ubuntu:trusty

MAINTAINER Andreas Botzler <botzler@jochen-schweizer.de>

# update
RUN apt-get update
RUN apt-get upgrade -y

# install dependencies
RUN apt-get install -y python-pip
RUN apt-get install -y python-dev
RUN apt-get install -y build-essential
RUN apt-get install -y libmysqlclient-dev

# create data directory
RUN mkdir /django

# set directory for entrypoint
WORKDIR /django

ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
