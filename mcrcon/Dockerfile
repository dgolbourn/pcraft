FROM archlinux:base
RUN mkdir -p /app
WORKDIR /app
RUN curl -fsSL -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz
RUN tar -xvzf mcrcon.tar.gz
ENTRYPOINT ["/app/mcrcon"]