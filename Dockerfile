# =========================
# Étape 1 : Builder Spring Boot
# =========================
FROM eclipse-temurin:21-jdk AS builder-spring
WORKDIR /app
COPY civilink/ ./civilink/
WORKDIR /app/civilink
# Build Spring Boot sans tests
RUN ./mvnw clean package -DskipTests

# =========================
# Étape 2 : Builder Flutter Web
# =========================
FROM cirrusci/flutter:stable AS builder-flutter
WORKDIR /app
# Copier le projet Flutter
COPY mon-quartier-vigilant-main-1/mon-quartier-vigilant-main/ ./flutter_app/
WORKDIR /app/flutter_app
# Build pour le web en release (plus besoin de flutter channel / upgrade / doctor)
RUN flutter build web --release

# =========================
# Étape 3 : Image finale
# =========================
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copier le backend Spring Boot
COPY --from=builder-spring /app/civilink/target/civilink-0.0.1-SNAPSHOT.jar ./app.jar

# Copier le frontend Flutter dans Spring Boot static (frontend)
COPY --from=builder-flutter /app/flutter_app/build/web ./frontend

# Exposer le port du backend
EXPOSE 8080

# Lancer l’application Spring Boot
CMD ["java", "-jar", "app.jar"]