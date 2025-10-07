FROM eclipse-temurin:17-jre

WORKDIR /app

COPY target/student-management-*.jar app.jar

EXPOSE 8089

ENTRYPOINT ["java", "-jar", "app.jar"]