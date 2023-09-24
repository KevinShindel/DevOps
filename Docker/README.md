# DOCKER

![Docker](https://avatars.githubusercontent.com/u/5429470?s=280&v=4)


### Install docker 

````shell
curl --request GET -sL \
     --url 'https;//get.docker.com'\
     --output '/tmp/install'
cat /tmp/install
chmod +x /tmp/install.sh
/tmp/install.sh
````

### Add docker to usergroup and launch service

``` shell
sudo usermod -aG docker $USER
sudo service docker start
```

### Docker publish image to Docker HUB

````shell
docker login -u username -p password
docker build -t image_name:0.1 .
docker tag image_name username/image_name
docker push username/image_name
````

### Docker image inspection

````shell
docker images sh1nd3l/flask-server:0.5 
docker history sh1nd3l/flask-server:0.5 
docker diff d4e68b2fcabd 
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $INSTANCE_ID
docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' $INSTANCE_ID
docker inspect --format='{{.LogPath}}' $INSTANCE_ID
docker inspect --format='{{json .Config}}' $INSTANCE_ID
````

### Work with images

| command  | description                               | example                                 |
|----------|-------------------------------------------|-----------------------------------------|
| build    | create image from Dockerfile              | <code>docker build .</code>             |
| build -f | create image from custom named dockerfile | <code>docker build -f NameOfFile</code> |
| rmi      | Remove image                              | <code>docker rmi $IMAGE_ID</code>       |
| search   | Search images in Docker HUB               | <code>docker search image_name </code>  |

### Work with containers

| command | description                                    | example                                                        |
|---------|------------------------------------------------|----------------------------------------------------------------|
| ps      | show running containers                        | <code>docker ps</code>                                         |
| ps -a   | show all containers                            | <code>docker ps -a </code>                                     |
| run     | create and run container from image            | <code>docker run image_name</code>                             |
| rm      | delete container                               | <code>docker rm $CONDAINER_ID</code>                           |
| -it     | Run container interactive                      | <code>docker run -it tomcat</code>                             |
| -d      | Run container in daemon mode ( on background ) | <code>docker run -d tomcat</code>                              |
| stop    | Stop container                                 | <code>docker stop $CONTAINER_ID </code>                        |
| -rm     | Run container and delete after exit            | docker run -rm tomcat                                          |
| exec    | Enter into running container                   | <code>docker exec -it CONTAINER_ID /bin/bash</code>            |
| -v      | Mount local folder into container              | <code>docker run --rm -it -v $(pwd)/app:/opt/app server</code> |

### Common commands

| command | description                | example                                                     |
|---------|----------------------------|-------------------------------------------------------------|
| commit  | ????                       | <code>docker commit CONTAINER_ID name:tag</code>            |
| prune   | Cleann all docker data     | <code>docker system prune -af --volumes</code>              |
| rm -v   | Clean all stopped images   | <code>docker rm -v $(docker ps -aq -f status=exited)</code> |
| rm      | Clean docker image history | <code>docker rm $(docker ps -aq)</code>                     |
