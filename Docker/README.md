
#DOCKER 
![Docker](https://avatars.githubusercontent.com/u/5429470?s=280&v=4)
### Add docker to usergroup
`` sudo usermod -aG docker $USER```

### Show images
``` docker images ```

### Show running containers
``` docker ps ```
``` docker ps -a ```

### Run Images
``` docker run image_name```

### Delete Container
``` docker rm CONTAINER_ID```

### Delete Image
``` docker rmi IMAGE_ID ```

### Search Images 
``` docker search IMAGEN_NAME ```

### Run Image (interactive)
``` docker run -it -p 80:8080 tomcat ```

### Run Image (deamon)
``` docker run -d -p 80:8080 tomcat ```

### Stop Container
``` docker stop CONTAINER_NAME ```

### Build Image from Dockerfile
``` docker build image_name:image_tag .```

### Enter to the container 
``` docker exec -it CONTAINER_ID /bin/bash ```

### Commit
``` docker commit CONTAINER_ID name:tag```