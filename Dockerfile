FROM openjdk:8-jre

RUN mkdir -p /opt/druid

ENV DRUID_VERSION 0.13.0-incubating

WORKDIR /opt/druid

RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*
RUN curl "http://ftp.cuhk.edu.hk/pub/packages/apache.org/incubator/druid/$DRUID_VERSION/apache-druid-$DRUID_VERSION-bin.tar.gz" \
	| tar zxf - --strip-components 1 -C /opt/druid

RUN java -cp "lib/*" -Ddruid.extensions.directory="extensions" org.apache.druid.cli.Main tools \
	pull-deps \
		--no-default-hadoop \
		-c org.apache.druid.extensions.contrib:kafka-emitter \
		-c org.apache.druid.extensions.contrib:druid-google-extensions

COPY conf /opt/druid/conf/
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p /tmp/druid /opt/druid/var/segment-cache /var/logs/druid/

ENTRYPOINT ["/docker-entrypoint.sh"]
