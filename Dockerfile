FROM sgrankin/docker-openjdk32

RUN apk add --no-cache runit

ARG VERSION=2.13.7
ADD https://www.gerritcodereview.com/download/gerrit-$VERSION.war /gerrit.war

COPY entrypoint.sh /entrypoint.sh

VOLUME /data
EXPOSE 8080, 29418

CMD ["/entrypoint.sh"]
