# Usa a imagem Ubuntu como base
FROM ubuntu:latest

# Instala dependências necessárias
RUN apt-get update && \
    apt-get install -y curl unzip openjdk-17-jdk

# Define variáveis de ambiente
ENV GRADLE_VERSION=8.8
ENV PGHOST=exemplo_host
ENV PGPORT=5432
ENV PGDATABASE=santanderdb
ENV PGUSER=linsglf
ENV PGPASSWORD=ihwiQljjN4yRvJ440FcccZpfhgASHcHS

# Define o diretório de trabalho
WORKDIR /app

# Baixa e configura o Gradle 8.8
RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip && \
    unzip gradle.zip -d /opt && \
    rm gradle.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/local/bin/gradle

# Copia o JAR da aplicação Spring para o contêiner
COPY build/libs/*.jar /app/app.jar

# Expor a porta 8080
EXPOSE 8080

# Comando para executar a aplicação Spring
CMD ["java", "-jar", "/app/app.jar"]
