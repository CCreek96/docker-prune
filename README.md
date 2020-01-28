# docker-prune
docker-prune is a Docker image used to automate garbage collection of images, containers, networks, or volumes written in Bash. 

## Usage
### Docker run
To create a docker-prune container which will run every 24 hours and clean up dangling containers, networks, and images which were created more than 24 hours ago, first pull the image

```
docker pull cacreek/docker-prune:latest
```

then run the command

```
docker run -d \
  --name=docker-prune \
  --restart unless-stopped \
  -e OPTIONS=system \
  -e SLEEP=86400 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  cacreek/docker-prune \
  --filter "until=24h"
```

### Docker compose
To use docker-prune with docker-compose, you can use something similar to

```
version: '3'
services:
  docker-prune:
    image: cacreek/docker-prune
    container_name: docker-prune
    restart: unless-stopped
    command: --filter "until=24h"
    environment:
      - OPTIONS=system
      - SLEEP=86400
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

## Options
Options are used to specify what type of items should be removed. Multiple options are allowed to be used together by providing them seperated by commas. If no options are provided then the system option is used by default.

The available options are:

| Options   | Meaning                                                     |
|:---------:|:------------------------------------------------------------|
| `system`  | remove dangling containers, networks, and images (default)  |
| `image`   | remove unused images                                        |
| `network` | remove unused networks                                      |
| `volumes` | remove unused volumes                                       | 

## Commands
The commands are used to control which items from an option should be removed. Some commands are only allowed to be used with a specific option, however if they are still provided then they will be removed at runtime and the command will still be allowed to run.

The available commands are:

| Commands                       | Meaning                                                                         |                    |:------------------------------:|:--------------------------------------------------------------------------------|
| `--filter "until=<timestamp>"` | only prune if created *before* the given timestamp                              |
| `--filter "label=<key>"`       | only prune if they have the specified label                                     |
| `--all, -a`                    | prune all items rather than just dangling (only for system and image options)   |
| `--volumes`                    | prune volumes (only for system option)                                          |


## Related Docker Documentation
[Docker system prune](https://docs.docker.com/engine/reference/commandline/system_prune/) 
[Docker image prune](https://docs.docker.com/engine/reference/commandline/image_prune/)
[Docker network prune](https://docs.docker.com/engine/reference/commandline/network_prune/)
[Docker volume prune](https://docs.docker.com/engine/reference/commandline/volume_prune/)
