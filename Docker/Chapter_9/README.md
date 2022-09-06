## Docker image deployment in cloud
```text
- Google Kubernetis Engine (GKE)
- Amazon Elastic Container Service (Amazon ECS)
- Giant Swarm
- Triton
```

### Docker-Machine using

#### Install docker
```shell
 sudo apt-get update \ 
 && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
 && sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   buster \
   stable" \
 && sudo apt-get update \
 && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```


#### Install docker-machine
```shell
curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
 ```

#### List images for Digital Ocean
```shell
 curl -X GET --silent "https://api.digitalocean.com/v2/images?per_page=999" -H "Authorization: Bearer $($DIGITAL_OCEAN_TOKEN)" > digital-ocean-images.json
```
#### Create droplet in digital ocean
```shell
docker-machine create \ 
              --driver digitalocean \
              --digitalocean-image debian-11-x64 \
              --digitalocean-access-token $(DIGITAL_OCEAN_TOKEN) \
              docker-machine-name
```

#### Get list of all containers
```shell
docker-machine ls
```

#### Get container IP
```shell
docker-machine ip docker-machine-name
```

#### Stop container
```shell
docker-machine stop docker-machine-name
```

#### Remove container
```shell
docker-machine rm -f docker-machine-name
```

##### Creating Docker Containers on a Remote Dockerized Host
```shell
docker-machine use machine-name \ 
&& docker run -d -p 8080:80 --name httpserver nginx
```

#### Show all images on remote host
```shell
docker images
```

#### Show all running images
```shell
docker ps
```

# Nginx setup
```shell
docker run -d --name nginx-base -p 80:80 nginx:latest && curl localhost:80
```

#### Copy config from container
```shell
docker cp nginx-base:/etc/nginx/conf.d/default.conf .default.conf
```

#### Copy config into container
```shell
docker cp default.conf nginx-base:/etc/nginx/conf.d/default.conf
```

#### Check nginx config in container
```shell
docker exec nginx-base nginx -t
```

#### Restart nginx service in container
```shell
docker exec nginx-base nginx -s reload
```