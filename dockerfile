
FROM maven:3.8.5-eclipse-temurin-17 as build

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jdk
WORKDIR /app


COPY --from=build /app/target/aws-repo-1.0-SNAPSHOT.jar app.jar


ENTRYPOINT ["java", "-jar", "app.jar"]

