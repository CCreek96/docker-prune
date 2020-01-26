FROM docker:19.03.5

MAINTAINER Connor Creek <creek.connor@yahoo.com>

RUN apk add --no-cache bash

COPY docker_prune.sh /docker_prune.sh
ENTRYPOINT ["/docker_prune.sh"]
