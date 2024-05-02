FROM eclipse-temurin:21-jre-alpine

RUN apk update \
    && apk upgrade \
    && apk add --update-cache bash \
    && rm -rf /var/cache/apk/*

VOLUME /truststore
VOLUME /ca-certs

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
