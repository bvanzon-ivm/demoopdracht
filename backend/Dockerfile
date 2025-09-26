# --- Build stage ---
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Kopieer pom.xml en download dependencies (caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Kopieer broncode en build
COPY src ./src
RUN mvn clean package -DskipTests

# --- Runtime stage ---
FROM eclipse-temurin:21-jre
WORKDIR /app

# Kopieer de gebuilde JAR uit de build stage
COPY --from=build /app/target/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Start de app
ENTRYPOINT ["java", "-jar", "app.jar"]
