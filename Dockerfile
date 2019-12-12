FROM governmentpaas/curl-ssl:latest as download
ARG version=1.4.1
ARG download=https://github.com/smartloli/kafka-eagle-bin/archive/v${version}.tar.gz
WORKDIR /app
RUN curl -o kafka-eagle.tar.gz $download \
    && tar zxf kafka-eagle.tar.gz \
    && ls -l\
    && mv kafka-eagle-bin-${version} kafka-eagle \
    && rm -rf kafka-eagle.tar.gz \
    && echo "rm and ls" \
    && ls kafka-eagle \
    && chmod +x kafka-eagle/bin/ke.sh

FROM openjdk:8-jre-alpine
ENV KE_HOME /app/kafka-eagle
ENV PATH $PATH:$KE_HOME/bin
WORKDIR /app
COPY --from=download /app/kafka-eagle /app/kafka-eagle
ENTRYPOINT ["sh", "${KE_HOME}/bin/ke.sh"]
