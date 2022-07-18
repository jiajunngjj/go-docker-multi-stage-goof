# builder
FROM golang:1.13.4-alpine AS build
WORKDIR /go/src/app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o /go/bin/greet ./cmd/greet/

# build app with snyk to run scan 
FROM build AS build-with-snyk
RUN apk add --no-cache curl
RUN curl -o ./snyk-alpine https://static.snyk.io/cli/latest/snyk-alpine && \
    curl -o ./snyk-alpine.sha256 https://static.snyk.io/cli/latest/snyk-alpine.sha256 && \
    sha256sum -c snyk-alpine.sha256 && \
    mv snyk-alpine /usr/local/bin/snyk && \
    chmod +x /usr/local/bin/snyk


# final image
FROM golang:1.15.8-alpine AS full
COPY --chown=65534:65534 --from=build /go/bin/greet .
USER 65534

ENTRYPOINT [ "./greet" ]

