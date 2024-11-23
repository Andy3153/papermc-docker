# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
FROM debian:unstable-slim

LABEL maintainer="Andrei Dobrete (andy3153@protonmail.com)"
LABEL description="Docker image for PaperMC"

COPY setup.sh /
COPY papermcctl /
COPY startServer.sh /

COPY server_config/eula.txt /
COPY server_config/server.properties /

# Getting PaperMC
RUN /setup.sh

CMD su papermc -c "papermcctl start"
