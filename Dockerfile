FROM maven:3.9.16-eclipse-temurin-21-alpine AS builder
# Create an app directory and cd to app
WORKDIR /app
# Copy pom.xml to app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests
# MULTI STAGE DOCKER IMAGE
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]