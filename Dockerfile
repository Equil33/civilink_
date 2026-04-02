# Builder Spring Boot
FROM eclipse-temurin:21-jdk AS builder-spring
WORKDIR /app
COPY civilink/ ./civilink/
WORKDIR /app/civilink
RUN ./mvnw clean package -DskipTests

# Builder Flutter Web
FROM cirrusci/flutter:stable AS builder-flutter
WORKDIR /app
COPY mon-quartier-vigilant-main-1/mon-quartier-vigilant-main/ ./flutter_app/
WORKDIR /app/flutter_app
RUN flutter build web

# Image finale
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copier backend
COPY --from=builder-spring /app/civilink/target/civilink-0.0.1-SNAPSHOT.jar ./app.jar

# Copier frontend dans Spring Boot static
COPY --from=builder-flutter /app/flutter_app/build/web ./frontend

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]