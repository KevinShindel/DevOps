0. Swarm initialization
````shell
docker swarm init
````
1.Start the registry as a service on your swarm:
````shell
docker service create --name registry --publish published=5000,target=5000 registry:2
````
2.Check its status with docker service ls
````shell
docker service ls
````
 
3.Check that it’s working with curl:
````shell
curl http://localhost:5000/v2/
````
4. Test the app with Compose
````shell
docker-compose up -d
````
5. Check that the app is running
````shell
docker-compose ps
````
6. test the app with curl
````shell
curl http://localhost:8000
curl http://localhost:8000
curl http://localhost:8000
````

7. Bring the app down
````shell
docker-compose down --volumes
````

# Push the generated image to the registry
````shell
docker-compose push
````

# Deploy the stack to the swarm
1. Create the stack
````shell
 docker stack deploy --compose-file docker-compose.yml stackdemo
````
2. Check that it’s running
````shell
docker stack services stackdemo
````
3. Test the app with curl
````shell
 curl http://localhost:8000
 curl http://localhost:8000
 curl http://localhost:8000
````
4. Bring the stack down 
````shell
docker stack rm stackdemo
````
5. Bring the registry down
````shell
docker service rm registry
````
6. If you’re just testing things out on a local machine and want to bring your Docker Engine out of swarm mode
````shell
 docker swarm leave --force
````