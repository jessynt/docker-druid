FROM openjdk:8-jre

ENV DRUID_HOME=/usr/local/druid
RUN mkdir -p $DRUID_HOME

ENV DRUID_VERSION 0.12.3

WORKDIR $DRUID_HOME

RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*
RUN curl "http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz" \ 
	| tar zxf - --strip-components 1 -C $DRUID_HOME

RUN java -cp "lib/*" -Ddruid.extensions.directory="extensions" io.druid.cli.Main tools \
	pull-deps \
		--no-default-hadoop \
		-c io.druid.extensions.contrib:kafka-emitter

COPY conf $DRUID_HOME/conf/
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /tmp/druid

ENTRYPOINT ["/docker-entrypoint.sh"]
