## build container
FROM golang:1.11.5 AS build-env

RUN apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

ENV GOPATH="/go"
WORKDIR $GOPATH/src/github.com/lsgrep/subspace
ADD . $GOPATH/src/github.com/lsgrep/subspace
#RUN go mod download

ARG BUILD_VERSION=unknown
ENV GODEBUG="netdns=go http2server=0"
ENV GO111MODULE="on"

#RUN go-bindata --pkg main static/... templates/... email/... \
#    && go fmt \
#    && go vet --all

RUN go get ./...
RUN go generate -v -x


RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -v --compiler gc --ldflags "-extldflags -static -s -w -X main.version=${BUILD_VERSION}" -o /usr/bin/subspace-linux-amd64


## final container
FROM phusion/baseimage:0.11

COPY --from=build-env /usr/bin/subspace-linux-amd64 /usr/bin/subspace
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENV DEBIAN_FRONTEND noninteractive

RUN chmod +x /usr/bin/subspace /usr/local/bin/entrypoint.sh

RUN apt-get update \
    && apt-get install -y iproute2 iptables dnsmasq socat wireguard-tools

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "/sbin/my_init" ]
