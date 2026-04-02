# =========================
# Étape 1 : Builder Spring Boot
# =========================
FROM eclipse-temurin:21-jdk AS builder-spring

WORKDIR /app
COPY civilink/ ./civilink/
WORKDIR /app/civilink
RUN ./mvnw clean package -DskipTests

# =========================
# Étape 2 : Builder Flutter Web compatible Dart 3.13+
# =========================
FROM cirrusci/flutter:3.13.0 AS builder-flutter

WORKDIR /app
COPY mon-quartier-vigilant-main-1/mon-quartier-vigilant-main/ ./flutter_app/
WORKDIR /app/flutter_app

# Build Flutter Web pour production
RUN flutter pub get
RUN flutter build web --release

# =========================
# Étape 3 : Image finale
# =========================
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app
COPY --from=builder-spring /app/civilink/target/civilink-0.0.1-SNAPSHOT.jar ./app.jar
COPY --from=builder-flutter /app/flutter_app/build/web ./frontend

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]