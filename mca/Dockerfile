FROM eclipse-temurin:17-jre-focal
RUN mkdir -p /app
WORKDIR /app
RUN curl -fsSL -o mcaselector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar
ADD ./start.sh /app
ENTRYPOINT [ "/app/start.sh" ]