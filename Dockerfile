FROM alpine/git as clone
ARG url=https://github.com/smartloli/kafka-eagle.git
WORKDIR /app
RUN git clone ${url}

FROM maven:3.6-jdk-8-alpine as build
COPY --from=clone /app /app
WORKDIR /app/kafka-eagle
RUN mvn clean \
    && mvn package -DskipTests

FROM openjdk:8-jre-alpine
ARG version=1.4.1
ENV KE_HOME /app/kafka-eagle
ENV PATH $PATH:$KE_HOME/bin 
WORKDIR /app
COPY --from=build /app/kafka-eagle/kafka-eagle-web/target/kafka-eagle-web-${versioon}-bin.tar.gz /app
RUN tar zxf kafka-eagle-web-${versioon}-bin.tar.gz \
    && rm -rf kafka-eagle-web-${versioon}-bin.tar.gz \
    && mv kafka-eagle-web-${versioon}-bin kafka-eagle \
    && chmod +x bin/ke.sh
ENTRYPOINT ["sh", "${KE_HOME}/bin/ke.sh"]
