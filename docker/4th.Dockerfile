# syntax = docker/dockerfile:1.0-experimental
FROM ubuntu:19.04 AS apt-cache
RUN apt-get update


FROM ubuntu:19.04 AS base
RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    > /etc/apt/apt.conf.d/keep-cache


FROM base AS builder
RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y --no-install-recommends curl git ca-certificates
RUN curl -s -o go.tar.gz https://dl.google.com/go/go1.12.linux-amd64.tar.gz \
  && tar xzf go.tar.gz -C /usr/local

ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin
RUN --mount=type=cache,target=/root/go/src \
    --mount=type=cache,target=/root/.cache/go-build \
    go get -u github.com/greymd/ojichat \
  && find /usr/local/go/src /root/go/src -type f \
    | grep -Ei 'license|readme' \
    | xargs -I@ echo "mkdir -p /tmp@; cp @ /tmp@" \
    | sed -e 's!/[^/]*;!;!' | bash


FROM base AS runtime
ENV LANG ja_JP.UTF-8
ENV PATH $PATH:/usr/games

RUN --mount=type=bind,target=/var/lib/apt/lists,from=apt-cache,source=/var/lib/apt/lists \
    --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get install -y --no-install-recommends cowsay language-pack-ja locales

COPY --from=builder /root/go/bin /usr/local/bin
COPY --from=builder /tmp/usr/local/go /usr/local/go
COPY --from=builder /tmp/root/go /root/go

RUN rm /etc/apt/apt.conf.d/keep-cache
COPY --from=ubuntu:19.04 /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-clean
