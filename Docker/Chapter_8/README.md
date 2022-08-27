## Testing in docker container

#### Create file named test.py


## Docker-in-Docker technology

```shell
docker run --rm --privileged -t -i -e LOG=file jpetazzo/dind
``` 

## Jenkins in Docker

#### Build jenkins container
```shell
cd DockerJenkins
docker build -t jenkins .
docker run -v /var/run/docker.sock:/var/run/docker.sock jenkins sudo docker ps
```
#### Create 
```shell
docker run --name jenkins-data jenkins echo 'jenkins data container' 
```

#### Run Jenkins container
```shell
docker run -d --name jenkins -p 8080:8080 --volumes-from jenkins-data -v /var/run/docker.sock:/var/run/docker.sock jenkins
```

