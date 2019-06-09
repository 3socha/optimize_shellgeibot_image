FROM ubuntu:19.04

RUN apt-get update
RUN apt-get install -y curl git cowsay language-pack-ja

RUN curl -sL -o go.tar.gz https://dl.google.com/go/go1.12.linux-amd64.tar.gz
RUN tar xf go.tar.gz -C /usr/local

ENV LANG ja_JP.UTF-8
ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin:/root/go/bin:/usr/games

RUN go get github.com/greymd/ojichat
