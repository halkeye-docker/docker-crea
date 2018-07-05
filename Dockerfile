FROM ubuntu:latest
MAINTAINER Gavin Mogan <docker@gavinmogan.com>


ENV DEBIAN_FRONTEND noninteractive
VOLUME /worlds
EXPOSE 5555/udp

RUN groupadd -r steam && \
  useradd -r -d /home/steam -g steam steam && \
  apt-get update && \
  apt-get install -y \
  lib32gcc1 \
  curl \
  libpython2.7 \
  python-pil \
  libvorbisenc2 \
  libvorbisfile3 \
  libflac8 \
  libxrandr2 \
  xvfb && \
  apt-get clean && \
  mkdir -p /home/steam && \
  curl http://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    | tar -C /home/steam -xzf - && \
  chown -R steam:steam /home/steam && \
  mkdir -p /worlds && \
  chown -R steam:steam /worlds

RUN printf "#!/bin/sh\nset -x\n(\n/usr/bin/xvfb-run -a \$@\n)\n" > /bin/xvfb-run-wrapper.sh && chmod 755 /bin/xvfb-run-wrapper.sh
RUN rm -rf /var/lib/apt/lists/*
#USER steam

RUN /home/steam/steamcmd.sh +@ShutdownOnFailedCommand 1 +login anonymous \
    +force_install_dir /home/steam/steamapps/crea \
    "+app_update 414570" validate \
    +quit && \
    ln -s /worlds /home/steam/steamapps/crea/worlds && \
    rm -rf ~/Steam/logs/*

WORKDIR /home/steam/steamapps/crea/
## FIXME - move this to the entrypoint
RUN printf '#!/bin/bash\n\
printf "{\\n\\t\\"autostart\\": \\"${CREA_WORLD_NAME}\\",\\n\\t\\"port\\": 5555,\\n\\t\\"password\\": \\"${CREA_PASSWORD}\\",\\n\\t\\"player_mode\\": 0,\\n\\t\\"max_players\\": 32,\\n\\t\\"spawn_monsters\\": true,\\n\\t\\"spawn_animals\\": true\\n}\\n" > /home/steam/steamapps/crea/server_settings \n\
cd /home/steam/steamapps/crea/ \n\
exec bash -x /bin/xvfb-run-wrapper.sh /home/steam/steamapps/crea/Standalone \n\
' > /home/steam/steamapps/crea/run.sh && chmod 755 /home/steam/steamapps/crea/run.sh

CMD ["/home/steam/steamapps/crea/run.sh"]

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

