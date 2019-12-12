FROM governmentpaas/curl-ssl:latest as download
ARG version=1.4.1
ARG download=https://github.com/smartloli/kafka-eagle-bin/archive/v${version}.tar.gz
WORKDIR /app
RUN curl -fsSL -O $download \
    && ls -l \
    && echo "download success" \
    && tar -zxf v${version}.tar.gz \
    && rm -rf v${version}.tar.gz \
    && ls -l \
    && tar -zxf v${version}/kafka-eagle-web-${version}-bin.tar.gz \
    && rm -rf v${version} \
    && mv kafka-eagle-web-${version} kafka-eagle \
    && echo "rm and ls" \
    && ls kafka-eagle \
    && chmod +x kafka-eagle/bin/ke.sh

FROM openjdk:8-jre-alpine
ENV KE_HOME /app/kafka-eagle
ENV PATH $PATH:$KE_HOME/bin
WORKDIR /app
COPY --from=download /app/kafka-eagle /app/kafka-eagle
ENTRYPOINT ["sh", "${KE_HOME}/bin/ke.sh"]
