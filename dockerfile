FROM maven:3.8.5-eclipse-temurin-17 as build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

LABEL maintainer="snehadhage96" version="1.0.1"

ENTRYPOINT ["java", "-jar", "app.jar"]
