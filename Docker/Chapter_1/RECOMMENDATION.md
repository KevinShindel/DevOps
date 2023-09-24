# Best Practice for Dockerfile

### Dockerfile introduction
````dockerfile
ARG NODE_VERSION=15.11.0-buster-slim
# choose required version
FROM node:$NODE_VERSION 
# notice to developer to open port 3000
EXPOSE 3000 
# select workdir in container
WORKDIR /app
# copy requirements
COPY ./package.json .
# install requirements
RUN npm install \
    # clean cache for npm
    && npm cache clean --force
# copy code part
COPY ./index.js .
# set correct user
USER node
# run server
CMD ["index.js"]
````


### Clear cache for APT
````dockerfile
ARG LATEST_VERSION=14
ARG NGINX_VER=1.18.0-6

FROM ubuntu:$LATEST_VERSION

MAINTAINER TymurHilfatullin
LABEL authors="Tymur_Hilfatullin"

RUN apt-get update \
    # install without recommends
    && apt-get install -y --no-install-recommends nginx=$NGINX_VER \
    # clean cache
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["top", "-b"]
````

### Buildkit

- enable buildkit
1. via file config (/etc/docker/daemon.json)
````json
{
  "features": {
    "buildkit": true
  }
}
````
2. via ENV 
````shell
$env:DOCKER_BUILDKIT = 1
export DOCKER_BUILDKIT=1
````
3. via one time build
````shell
$env:DOCKER_BUILDKIT = 1
docker build -t demo .
$env:DOCKER_BUILDKIT = 0
````

### Multi-stage build
````dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS builder
WORKDIR /app

COPY ./demo/*.csproj ./
RUN dotnte restore
COPY ./demo ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=builder ./app/out .
ENTRYPOINT ["dotnet", "demo.dll"]
````

### build target
````dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS builder
####
FROM node:15.11.0-buster-slim as frontend
####
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
####
COPY --from=builder ./app/out .
COPY --from=frontend /frontend/build .
````

### mount (!copy)
````dockerfile
FROM golang:1.16 AS builder
WORKDIR $GOPATH/src/demo
COPY . .
RUN CGO_ENABLE=0 go build -tags netgo -a -o /go/bin/demo ./main.go
FROM alpine
COPY --from=builder /go/bin/demo /go/bin/demo
ENTRYPOINT ["/go/bin/demo"]
````

### SSH-agent forwarding
````dockerfile
RUN --mount=type=ssh git clone git@github.com:..... commentci
````
````shell
docker build --ssh default -t demo . 
````

### build args

````dockerfile
ARG image=alpine
FROM golang:1.16 as builder
####
FROM ${image} as demo:type-${image}
COPY --from=builder /go/bin/demo /go/bin/demo
ENTRYPOINT ["/go/bin/demo"]
````

````shell
docker build --build-arg image=busybox -t godemo:mount .
````

### ENV vs ARG
````dockerfile
FROM aplpine:3.13
ENV SUPER_SECRET=P@ssW0Rd
RUN echo $SUPER_SECRET
ENTRYPOINT ["env"]
````

````shell
docker build -e SUPER_SECRET=p@ssWord -t demo:secret .
````
````dockerfile
FROM aplpine:3.13
ARG SUPER_SECRET=NONE
RUN echo $SUPER_SECRET
ENTRYPOINT ["env"]
````

````shell
docker build --build-arg SUPER_SECRET=p@ssWord -t demo:secret .
````