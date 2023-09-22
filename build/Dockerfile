# Use carlosedp/golang for riscv64 support
FROM golang:1.21-bookworm AS build

# Install dependencies
RUN apt-get update && apt-get install -y git build-essential libsecret-1-dev

# Build
WORKDIR /build/
COPY build.sh VERSION /build/
RUN bash build.sh $(cat VERSION)

FROM ghcr.io/linuxserver/baseimage-ubuntu
LABEL maintainer="Antoine Aflalo <proton-bridge@aaflalo.me>"

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN apt-get update \
    && apt-get install -y --no-install-recommends socat pass libsecret-1-0 ca-certificates procps\
    && rm -rf /var/lib/apt/lists/*

# Copy bash scripts
COPY gpgparams entrypoint.sh /app/protonmail/

# Copy protonmail
COPY --from=build /build/proton-bridge/bridge /app/protonmail/
COPY --from=build /build/proton-bridge/proton-bridge /app/protonmail/

COPY root/ /
VOLUME /config