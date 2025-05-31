# ---------- Stage 1: Build WAR using Maven ----------
FROM maven:3.9.3-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .

# Build the WAR file and skip tests
RUN mvn clean install -DskipTests

# ---------- Stage 2: Run using Spring Boot ----------
FROM openjdk:17-jdk-slim

# Copy WAR file from build stage
COPY --from=builder /app/target/*.war app.war

# App will run on 8081 (matches application.properties)
EXPOSE 8081

# Run the Spring Boot WAR directly
ENTRYPOINT ["java", "-jar", "app.war"]
