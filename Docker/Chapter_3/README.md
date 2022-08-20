# Launch first image w params
```shell
docker run debian echo "Hello world from Docker"
```

# launch image via console
```shell
docker run -it debian /bin/bash
```
```shell
echo "hello from tty!"
exit
```
# Image details
```shell
docker inspect image_name
```

# Show IP Address on image
```shell
docker ps -a 
docker inspect image_name | grep IPAddress 
```

# Show changes in docker container
```shell
docker diff image_name
```

# Show logs from container
```shell
docker logs image_name
```

# Show all containers (stopped also)
```shell
docker ps -a
```

# Remove container
```shell
docker rm container_name or container_id
```

# Docker remove all stopped containers
```shell
docker rm -v $(docker ps -aq -f status=exited) 
```

# Run container with apps
```shell
docker run -it  --hostname cowsay --name cowsay debian bash
```
# Install apps
```shell
apt-get update && apt-get install cowsay fortune -y
```
# Run image due commit
```shell
docker commit cowsay username/cowsay_img
docker run username/cowsay_img /usr/games/cowsay "moo"
```

# Run image due dockerfile
```shell
docker -f path/to/dockerfile -t username/container_img
docker run username/container_img
```

# Pull/Push commands

```shell
docker push username/container_img
```

# Pull redis image
```shell
docker pull redis:latest
docker run redis --name -d redis_container
```

# Link between containers
```shell
docker run --rm -it --link myredis:redis redis -p 6379
redis-cli -h redis -p 6379
set foo 123456
get foo
```

# Using Volumes in docker (save dat into disk)
```shell
docker run -v /data 
docker run --rm --volumes-from myredis -v $(pwd)/backup:/backup debian cp /data/dump.rdb /backup/
```

# docker 