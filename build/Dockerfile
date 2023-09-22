# Use carlosedp/golang for riscv64 support
FROM golang:1.21-bookworm AS build

# Install dependencies
RUN apt-get update && apt-get install -y git build-essential libsecret-1-dev

# Build
WORKDIR /build/
COPY build.sh VERSION /build/
RUN bash build.sh

FROM debian:bookworm-slim
LABEL maintainer="Antoine Aflalo <git@aaflalo.me>"

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN apt-get update \
    && apt-get install -y --no-install-recommends socat pass libsecret-1-0 ca-certificates procps\
    && rm -rf /var/lib/apt/lists/*

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/proton-bridge/bridge /protonmail/
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

# Add a user 'protonmail' with UID 900
RUN useradd -u 900 -d /home/protonmail protonmail \
    && mkdir -p /home/protonmail \
    && chown protonmail: /home/protonmail
# change to non-privileged user for extra security

USER protonmail

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
