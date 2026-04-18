# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src
COPY .mvn ./.mvn
COPY mvnw .
COPY mvnw.cmd .

# Build the application
RUN ./mvnw clean package -DskipTests -Pprod

# Stage 2: Run the application
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Install Tesseract OCR dependencies as specified in eAI.docx.txt
RUN apk add --no-cache tesseract-ocr

# Copy the jar from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8084
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]
