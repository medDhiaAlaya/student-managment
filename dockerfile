# ---- Stage 1: Build the JAR ----
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

# Build the Spring Boot JAR (without tests for faster CI)
RUN mvn clean package -DskipTests

# ---- Stage 2: Create the runtime image ----
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy built JAR from builder
COPY --from=builder /app/target/*.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java","-jar","app.jar"]
