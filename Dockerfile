FROM alpine/git as clone
ARG url=https://github.com/smartloli/kafka-eagle.git
WORKDIR /usr/local
RUN git clone ${url}

FROM maven:3.6-jdk-8-alpine as build
WORKDIR /usr/local/kafka-eagle
COPY --from=clone /usr/local/kafka-eagle /usr/local/kafka-eagle
RUN mvn clean \
    && mvn package -DskipTests

FROM openjdk:8-jre-alpine
ENV KE_HOME /usr/local/kafka-eagle
ENV PATH $PATH:$KE_HOME/bin 
WORKDIR /usr/local/kafka-eagle
COPY --from=build /usr/local/kafka-eagle ${KE_HOME}
RUN tar zxf kafka-eagle-${version}-bin.tar.gz \
    && rm kafka-eagle-${version}-bin.tar.gz \
    && mv kafka-eagle-${version}-bin kafka-eagle \
	  && chmod +x bin/ke.sh
ENTRYPOINT ["sh", "${KE_HOME}/bin/ke.sh"]
