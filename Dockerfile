# build stage
FROM golang:1.14 AS build-env
ADD . /src
#disable crosscompiling
ENV CGO_ENABLED=0

#compile linux only
ENV GOOS=linux
RUN cd /src && go get -v -d && go build -ldflags '-w -s' -a -installsuffix cgo -o alertmanager-sns-forwarder

# final stage
FROM ubuntu
COPY --from=build-env /src/alertmanager-sns-forwarder /app/
COPY ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
WORKDIR /app
