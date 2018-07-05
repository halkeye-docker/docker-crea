FROM ubuntu:rolling
MAINTAINER Gavin Mogan <docker@gavinmogan.com>


ENV DEBIAN_FRONTEND noninteractive
EXPOSE 5555

RUN groupadd -r steam && \
  useradd -r -d /home/steam -g steam steam && \
  apt-get update && \
  apt-get install -y \
  lib32gcc1 \
  curl \
  libgl1-mesa-glx \
  libsndfile1 \
  libjpeg8 \
  libxrandr2 \
  libglib2.0-0 \
  libxi6 \
  libgtk2.0-0 \
  libnss3 \
  libgconf-2-4 \
  libasound2 \
  libssl1.0.0 \
  xvfb && \
  apt-get clean && \
  mkdir -p /home/steam && \
  curl http://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    | tar -C /home/steam -xzf - && \
  chown -R steam:steam /home/steam

USER steam

RUN /home/steam/steamcmd.sh +@ShutdownOnFailedCommand 1 +login anonymous \
    +force_install_dir /home/steam/steamapps/crea \
    "+app_update 414570" validate \
    +quit

WORKDIR /home/steam/steamapps/crea/bin/
CMD ["./standalone"]

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.version=$VERSION \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/halkeye/docker-crea.git" \
  org.label-schema.name="Crea Dedicated Server" \
  org.label-schema.vendor="Gavin Mogan" \
  org.label-schema.schema-version="1.0" \

