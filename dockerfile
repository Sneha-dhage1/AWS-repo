# First stage: build JAR
FROM maven:3.8.5-eclipse-temurin-17 as build

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Second stage: run JAR
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the JAR file
COPY --from=build /app/target/aws-repo-1.0-SNAPSHOT.jar app.jar

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

