FROM ubuntu:18.04

MAINTAINER Ove Ranheim (ove.ranheim@descoped.io)

ENV RUN_USER    daemon
ENV RUN_GROUP   daemon

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install apt-utils ca-certificates openssl wget curl vim ssh-client proxytunnel git iputils-ping

# ~/.ssh/config
# mkdir ~/.ssh
# copy config file to ~/.ssh/
# default entrypoint cmd: sh -c "cmd"

RUN mkdir -p /opt/proxytunnel \
    && chown -R ${RUN_USER}:${RUN_GROUP} /opt/proxytunnel

VOLUME /opt/proxytunnel/.ssh
WORKDIR /opt/proxytunnel

ENTRYPOINT ["/bin/sh", "-c", "ssh $SSH"]
#CMD ["/bin/bash"]

