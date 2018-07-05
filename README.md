Crea
====

Crea Docker Image

Includes:

* Downloaded latest server code at compile time
* All dependancies that are needed to run the server

Configuration
-------------

This is done by environment variables

* CREA_PASSWORD
* CREA_WORLD_NAME

Example
-------

docker run --rm -it \
  -p 5555:5555/udp \
  -v /storage/apps/crea/worlds:/worlds \
  -e CREA_WORLD_NAME=NewWorld \
  -e CREA_PASSWORD=SomePassword \
  --name crea \
  halkeye/crea

