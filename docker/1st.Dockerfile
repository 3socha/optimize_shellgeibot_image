FROM ubuntu:19.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl git ca-certificates cowsay language-pack-ja locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LANG ja_JP.UTF-8
ENV GOPATH /root/go
RUN curl -sS --retry 3 -o go.tar.gz https://dl.google.com/go/go1.12.linux-amd64.tar.gz \
  && tar xf go.tar.gz -C /usr/local \
  && rm go.tar.gz \
  && /usr/local/go/bin/go get github.com/greymd/ojichat \
  && find /usr/local/go /root/go/src -type f | grep -viE 'license|readme' | xargs rm \
  && find /usr/local/go /root/go/src -type d -empty -delete
ENV PATH $PATH:/root/go/bin:/usr/games
