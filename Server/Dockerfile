FROM maven:3.9.9-eclipse-temurin-8 AS builder

WORKDIR /build

COPY Server/pom.xml Server/pom.xml
RUN mvn -f Server/pom.xml -B -DskipTests dependency:go-offline

COPY Server/src Server/src
RUN mvn -f Server/pom.xml -B -DskipTests package

FROM eclipse-temurin:8-jre-jammy

WORKDIR /app

ENV TZ=Asia/Hong_Kong \
    USER_FILE_PATH=/app/userFile

COPY --from=builder /build/Server/target/server-1.0-SNAPSHOT.jar /app/server.jar
COPY userFile /opt/seed-userFile
COPY scripts/docker/server-entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && mkdir -p /app/userFile

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
