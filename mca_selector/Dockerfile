FROM gitpod/workspace-full-vnc

RUN apt-get update \
    && apt-get install -y openjfx libopenjfx-java matchbox \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN curl -fsSL -o mcaselector.jar https://github.com/Querz/mcaselector/releases/download/2.2.2/mcaselector-2.2.2.jar \ 
    && curl -fsSL https://cdn.azul.com/zulu/bin/zulu17.30.15-ca-fx-jre17.0.1-linux_x64.tar.gz \
    && mv mcaselector.jar /usr/local/bin/mcaselector.jar \
    && chmod +x /usr/local/bin/mcaselector.jar

ENTRYPOINT [ "executable" ]