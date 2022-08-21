# Basic Docker

## Docker build commands

+ docker build -t username/container_name .
```text
where . is current folder
```  
+ docker build -t username/container_name - < archive.tar.gz
```text
send context via STDIN, archive contains Dockerfile
```
+ docker build -t username/container_name -f path/to/Dockerfile

## Docker ignore files 
#### All rules must be included in file ``` .dockerignore ```

```text
.git      exclude file .git from current folder
*/.git    exclude file from sub folder
*/*/.git  exclude file from 2 level sub folder
*.sw?     exclude files with extensions .sw* but only in current folder
```

## Docker image levels
#### show all history of container changes
```shell
docker history debian:latest
```

## History sometimes helps with debuging builddocker 
```shell
docker build -t test_busybox .
```

``` Sending build context to Docker daemon  3.584kB
Step 1/3 : FROM busybox:latest
latest: Pulling from library/busybox
50783e0dfb64: Pull complete 
Digest: sha256:ef320ff10026a50cf5f0213d35537ce0041ac1d96e9b7800bafd8bc9eff6c693
Status: Downloaded newer image for busybox:latest
 ---> 7a80323521cc
Step 2/3 : RUN echo "this should work"
 ---> Running in e66d8f5dfa7b
this should work
Removing intermediate container e66d8f5dfa7b
 ---> f5497f891fd7 <--!!!!!
Step 3/3 : RUN /bin//bash -c echo "this won't!"
 ---> Running in 78c5bdd19414
/bin/sh: /bin//bash: not found
The command '/bin/sh -c /bin//bash -c echo "this won't!"' returned a non-zero code: 127
```

```
docker ps -a

CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                       PORTS     NAMES
daf3bad3bd73   f5497f891fd7   "sh"                     5 minutes ago   Exited (0) 42 seconds ago              festive_murdock
78c5bdd19414   f5497f891fd7   "/bin/sh -c '/bin//b…"   7 minutes ago   Exited (127) 7 minutes ago             condescending_cerf
                                               
                                               
docker history f5497f891fd7

IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
f5497f891fd7   7 minutes ago   /bin/sh -c echo "this should work"              0B        
7a80323521cc   3 weeks ago     /bin/sh -c #(nop)  CMD ["sh"]                   0B        
<missing>      3 weeks ago     /bin/sh -c #(nop) ADD file:03ed8a1a0e4c80308…   1.24MB    

```

#### Just run history container build and debug
```shell
docker run -it f5497f891fd7
```

```
  /bin/bash -c echo 'hello'
  sh: /bin/bash: not found
  / # /bin/sh -c "echo hello"
  hello
```

## Dockerfile instructions
``` official documentation https://docs.docker.com/engine/reference/builder/ ```

``` 
MAINTAINER kevin.shindel@yahoo.com                                             # just author of file
FROM debian:latest                                                             # used to select image for build
ADD --keep-git-dir=true https://github.com/moby/buildkit.git#v0.10.1 /buildkit # used for adding files, owners
ENV PATH=/opt                                                                  # added env variable
WORKDIR ${PATH}                                                                # change working directory
COPY entrypoint.sh .                                                           # just copy files and other things
RUN apt-get update && apt-get -y install apache2                               # used for run commands due container is build
RUN echo "Hello world, from docker" > /var/www/html/index.html
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]                               # launch custom commands with arguments
EXPOSE 80                                                                      # open ports
ENTRYPOINT ["/entrypoin.sh"]                                                   # used to run script after container is up
VOLUME /otp/project_path                                                       # mount volumes from container to host
ONBUILD RUN /usr/local/bin/python-build --dir /app/src                         # just run commands after image is builded
```

## Open ports from container into network
```text
docker run -d -p 8000:80 nginx # manual port binding

ID=$(docker run -d -P nginx)
docker port $ID 80 # docker automatically find open port and bind to 80
```

## Linking containers
```shell
docker run -d --name myredis redis
docker run --link myredis:redis debian env 
```

## Docker volumes management and mounting
#### Run container with mounted volume called data
```shell
docker run -it --name container-volume-test -h CONTAINER -v /data debian /bin/bash
```
#### inspect mounted volumes
```shell
docker inspect -f {{.Mounts}} container-volume-test
```

#### Mount local folder into container
```shell
docker run -it --name container-volume-test -h CONTAINER -v ~/data:/data debian /bin/bash
```
#### Create temp file and check it in docker folder
```shell
cd ~/data && touch readme.md
```