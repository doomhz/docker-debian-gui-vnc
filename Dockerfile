# Use Debian 12 as base image
FROM debian:12

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install LXQt, VNC server (x11vnc), Xvfb, dbus-x11, and required applications
RUN apt-get update && apt-get install -y \
    lxqt-core \
    x11vnc \
    xvfb \
    dbus-x11 \
    firefox-esr \
    thunderbird \
    keepassx \
    libreoffice \
    vim \
    less \
    curl \
    wget \
    --no-install-recommends \
    && apt-get install -y \
      supervisor sudo net-tools \
      dbus-x11 x11-utils alsa-utils \
      mesa-utils libgl1-mesa-dri \
    && apt-get install -y lxqt openbox

# tini to fix subreap
#ARG TINI_VERSION=v0.18.0
#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
#RUN chmod +x /bin/tini
RUN apt-get install -y tini

RUN apt-get update \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD xvfb.sh /usr/local/bin/

WORKDIR /root
ENV SHELL=/bin/bash

ENTRYPOINT ["/startup.sh"]
