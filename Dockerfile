FROM openjdk:8-jre

RUN mkdir -p /opt/druid

ENV DRUID_VERSION 0.12.3

WORKDIR /opt/druid

RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*
RUN curl "http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz" \
	| tar zxf - --strip-components 1 -C /opt/druid

RUN java -cp "lib/*" -Ddruid.extensions.directory="extensions" io.druid.cli.Main tools \
	pull-deps \
		--no-default-hadoop \
		-c io.druid.extensions.contrib:kafka-emitter

COPY conf /opt/druid/conf/
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /tmp/druid /opt/druid/var/segment-cache

ENTRYPOINT ["/docker-entrypoint.sh"]
