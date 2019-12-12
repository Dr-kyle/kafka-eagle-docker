FROM governmentpaas/curl-ssl:latest as download
ARG version=v1.4.1
ARG download=https://github.com/smartloli/kafka-eagle-bin/archive/${version}.tar.gz
WORKDIR /app
RUN curl -fsSL -o kafka-eagle.tar.gz $download \
    && tar zxf kafka-eagle.tar.gz \
    && ls \
    && rm -rf kafka-eagle.tar.gz \
    && chmod +x kafka-eagle/bin/ke.sh

FROM openjdk:8-jre-alpine
ENV KE_HOME /app/kafka-eagle
ENV PATH $PATH:$KE_HOME/bin
WORKDIR /app
COPY --from=download /app/kafka-eagle /app/kafka-eagle
ENTRYPOINT ["sh", "${KE_HOME}/bin/ke.sh"]
