FROM ubuntu:19.04 AS builder

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl git ca-certificates
RUN curl -s -o go.tar.gz https://dl.google.com/go/go1.12.linux-amd64.tar.gz \
  && tar xzf go.tar.gz -C /usr/local

ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin
RUN go get github.com/greymd/ojichat
RUN go get github.com/xztaityozx/owari
RUN find /usr/local/go/src /root/go/src -type f \
    | grep -Ei 'license|readme' \
    | xargs -I@ echo "mkdir -p /tmp@; cp @ /tmp@" \
    | sed -e 's!/[^/]*;!;!' | bash


FROM ubuntu:19.04 AS runtime
ENV LANG ja_JP.UTF-8
ENV PATH $PATH:/usr/games

RUN apt-get update \
  && apt-get install -y --no-install-recommends cowsay language-pack-ja locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/go/bin /usr/local/bin
COPY --from=builder /tmp/usr/local/go /usr/local/go
COPY --from=builder /tmp/root/go /root/go
