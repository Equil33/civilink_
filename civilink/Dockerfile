# Étape 1 : Builder le backend Spring Boot
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app
COPY civilink/ ./civilink/
WORKDIR /app/civilink
RUN ./mvnw clean package -DskipTests

# Étape 2 : Image finale
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=builder /app/civilink/target/civilink-0.0.1-SNAPSHOT.jar ./app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]