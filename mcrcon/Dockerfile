FROM archlinux:latest
RUN pacman -Syu --noconfirm
RUN pacman -S base-devel git --noconfirm
RUN git clone https://github.com/Tiiffi/mcrcon.git
WORKDIR mcrcon
RUN make
RUN make install
ENTRYPOINT ["mcrcon"]