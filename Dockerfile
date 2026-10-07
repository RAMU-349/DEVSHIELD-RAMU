FROM eclipse-temurin:21.0.2_13-jdk-jammy

ENV SPRING_PROFILES_ACTIVE=prod

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

COPY target/novabank-transfer.jar app.jar

RUN groupadd --system appgroup && \
    useradd --system --gid appgroup --no-create-home appuser && \
    chown -R appuser:appgroup /app

USER appuser

EXPOSE 8082

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD curl -fsS http://localhost:8082/actuator/health || exit 1

CMD ["java", "-jar", "app.jar"]
