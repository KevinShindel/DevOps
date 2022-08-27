
## Image delivering

#### Get help about login logic
```shell
docker login --help
```

#### Login into docker hub
```shell
docker login -u username --password-stdin
```

#### Docker publish image
```shell
docker build -t flask_sever:0.1 .
docker tag "flask_sever:0.1" "sh1nd3l/flask-server:0.1"
docker push "sh1nd3l/flask-server:0.1"
```

#### Image size optimization 
```shell
docker build -t filetest .
docker images filetest
docker history filetest
```