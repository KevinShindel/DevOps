# Docker logging system

### Default logging system
```shell
docker run --name log_test debian sh -c 'echo "worked"'
docker logs log_test
docker logs -t log_test
```

### Stream logs (-f) with timestamp (-t)
```shell
 docker run -d --name streamtest debian sh -c 'while true; do echo "worked"; sleep 2; done;'
docker logs -t -f streamtest
```


### Logging with Logsout + Logstash
```shell
docker-compose -f logstash-compose.yml up
```

### Launch ELK + nginx + redis + dnmoster
```shell
docker-compose up -f elk-compose.yml
```