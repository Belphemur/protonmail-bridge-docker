# Use carlosedp/golang for riscv64 support
FROM golang:1.21-bookworm AS build

# Install dependencies
RUN apt-get update && apt-get install -y git build-essential libsecret-1-dev

# Build
WORKDIR /build/
COPY build.sh VERSION /build/
RUN bash build.sh $(cat VERSION)

FROM ghcr.io/linuxserver/baseimage-debian:bookworm
LABEL maintainer="Antoine Aflalo <proton-bridge@aaflalo.me>"

EXPOSE 1025/tcp
EXPOSE 1143/tcp

# Copy bash scripts
COPY gpgparams init-bridge.sh /app/protonmail/

# Install dependencies and protonmail bridge
RUN apt-get update \
    && apt-get install -y --no-install-recommends pass libsecret-1-0 ca-certificates net-tools procps\
    && rm -rf /var/lib/apt/lists/* \
    && ln -sr /app/protonmail/init-bridge.sh /usr/bin/init-bridge

# Copy protonmail
COPY --from=build /build/proton-bridge/bridge /app/protonmail/
COPY --from=build /build/proton-bridge/proton-bridge /app/protonmail/

COPY root/ /
VOLUME /config