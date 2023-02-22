FROM amazoncorretto:11-alpine AS builder
WORKDIR /opt/hello-springrest
COPY . .
RUN ./gradlew bootjar

FROM amazoncorretto:11-alpine AS runtime
WORKDIR /opt/hello-springrest
COPY --from=builder /opt/hello-springrest/build/libs/rest-service-0.0.1-SNAPSHOT.jar .
CMD ["java", "-jar", "rest-service-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080
