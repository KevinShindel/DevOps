# Docker Compose 


## Secrets 

> You can use secrets to manage any sensitive data which a container needs at runtime, but you 
> don't want to store in the image or in source control, such as:
>
> - Usernames and passwords
> - TLS certificates and keys
> - SSH keys
> - Other important data such as the name of a database or internal server
> - Generic strings or binary content (up to 500 kb in size) 

<details>
<summary>Details</summary>

<details>
<summary>Simple Secret</summary>

````yaml
version: '3.8'
services:
  main:
    image: bash:latest
    secrets:
      - my_secret
    stdin_open: true
    tty: true

secrets:
  my_secret:
    file:
      secret.txt
````
</details>
<details>
<summary>Advanced Secret</summary>

````yaml
services:
   db:
     image: mysql:latest
     volumes:
       - db_data:/var/lib/mysql
     environment:
       MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_root_password
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD_FILE: /run/secrets/db_password
     secrets:
       - db_root_password
       - db_password

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD_FILE: /run/secrets/db_password
     secrets:
       - db_password


secrets:
   db_password:
     file: db_password.txt
   db_root_password:
     file: db_root_password.txt

volumes:
    db_data:
````
</details>
</details>


## Arguments 

> Build arguments is a great way to add flexibility to your builds. You can pass build arguments 
> at build-time, and you can set a default value that the builder uses as a fallback.

<details>
<summary>Details</summary>

<details><summary>Simple</summary>

> paste args via cli <code>docker build --build-arg="GO_VERSION=1.19" .</code>

</details>

<details>
<summary>Advanced</summary>

> Override argument <code>docker build --build-arg="GO_VERSION=1.31" .</code>

````dockerfile
ARG GO_VERSION=1.20
FROM golang:${GO_VERSION}-alpine AS base
WORKDIR /src
RUN --mount=type=cache,target=/go/pkg/mod/ \
      --mount=type=bind,source=go.sum,target=go.sum \
      --mount=type=bind,source=go.mod,target=go.mod \
      go mod download -x

FROM base AS build-client
RUN --mount=type=cache,target=/go/pkg/mod/ \
      --mount=type=bind,target=. \
      go build -o /bin/client ./cmd/client

FROM base AS build-server
ARG APP_VERSION="v0.0.0+unknown"
RUN --mount=type=cache,target=/go/pkg/mod/ \
      --mount=type=bind,target=. \
      go build -ldflags "-X main.version=$APP_VERSION" -o /bin/server ./cmd/server

FROM scratch AS client
COPY --from=build-client /bin/client /bin/
ENTRYPOINT [ "/bin/client" ]

FROM scratch AS server
COPY --from=build-server /bin/server /bin/
ENTRYPOINT [ "/bin/server" ]
````

</details>

</details>


## Environment
> Environment variables can help you define various configuration values. 
> They also keep your app flexible and organized.

<details>
<summary>Details</summary>

<details><summary>Simple Env using</summary>

> Passing env via console: <code>docker compose run -e DEBUG=1 web python console.py</code>

> Passing env via config
````yaml
version: "3.8"
web:
  environment:
    - DEBUG=1
````

</details>

<details>
<summary>Advanced</summary>

> Passing the --env-file argument overrides the default file path:

````shell
docker compose --env-file ./config/.env.dev config
````

````yaml
web:
  env_file:
    - web-variables.env
````

</details>

</details>