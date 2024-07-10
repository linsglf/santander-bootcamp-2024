# Etapa de build
FROM ubuntu:latest AS build

# Instalação de dependências necessárias
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk curl && \
    apt-get clean;

# Configuração do ambiente Gradle
ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 8.8

# Download e instalação do Gradle
RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip && \
    unzip gradle.zip -d /opt && \
    rm gradle.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/local/bin/gradle

# Definindo variáveis de ambiente para o banco de dados PostgreSQL
ENV PGHOST dpg-cq71n1lds78s738o3vcg-a.oregon-postgres.render.com
ENV PGPORT 5432
ENV PGDATABASE santanderdb
ENV PGUSER seu_usuario
ENV PGPASSWORD sua_senha

# Diretório de trabalho
WORKDIR /app

# Copiando arquivos de build
COPY build.gradle settings.gradle ./
COPY src ./src

# Executando build com Gradle
RUN gradle build --no-daemon

# Etapa de runtime
FROM openjdk:17-jdk-slim

# Diretório de trabalho
WORKDIR /app

# Copiando artefato da etapa de build
COPY --from=build /app/build/libs/*.jar app.jar

# Expondo porta
EXPOSE 8080

# Comando para executar a aplicação Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
