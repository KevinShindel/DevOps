# Container lookup service

## Ambassadors
```shell
docker run -d --name real-redis redis:7
docker run -d --name real-redis-ambassador -p 6379:6379 --link real-redis amouat/ambassador
docker run -d --name redis_ambassador --expose 6379  \ 
-e REDIS_PORT_6379_TCP=tcp://$(docker inspect -f {{.NetworkSettings.IPAddress}} real-redis) amouat/ambassador
docker run -d --name dnmonster amouat/dnmonster:1.0
docker run -d  --name flask --link dnmonster:dnonster --link redis_ambassador:redis -p 80:8080 sh1nd3l/flask-server:0.5
curl $(docker inspect -f {{.NetworkSettings.IPAddress}} flask)
```

## Lookup services etcd

### 1.Get this image
```shell
docker pull bitnami/etcd:latest
```

### 2. Create network
```shell
 docker network create app-tier --driver bridge
```

### 3. Launch the Etcd server instance
```shell
 docker run -d --name Etcd-server \
    --network app-tier \
    --publish 2379:2379 \
    --publish 2380:2380 \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    --env ETCD_ADVERTISE_CLIENT_URLS=http://etcd-server:2379 \
    bitnami/etcd:latest
```

### 4. Launch your Etcd client instance
```shell
docker run -it --rm \
    --network app-tier \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    bitnami/etcd:latest etcdctl --endpoints http://etcd-server:2379 put /message Hello
```


## Lookup services SkyDNS
## TODO: Need investigate!

### 1. Run multiple mongo instances
```shell
docker run -d --name repl1 mongo --smallfiles
docker run -d --name repl2 mongo --smallfiles
docker run -d --name repl3 mongo --smallfiles
```

### 2. Pull SkyDNS 
```shell
docker pull crosbymichael/skydns
docker pull crosbymichael/skydock
```

### 3. Run SkyDNS server
```shell
docker run -d -p 172.17.42.1:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain docker
```

### 4. Run SkyDocker instances
```shell
docker run -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock -ttl 30 -environment dev -s /docker.sock -domain docker -name skydns
```

## Docker Network modes [none, container, host, bridge]

#### Docker позволяет использовать 5 режимов сети:
 
- **bridge** - программный режим моста. Docker по умолчанию использует сеть с названием bridge для всех контейнеров для общения в пределах одной машины, если для них не описываются другие сети.
- **overlay** - распределенная сеть между множественными хостами Docker для использования сервисами. В Swarm по умолчанию используется сеть типа overlay с именем ingress для распределения нагрузки, а так же сеть типа bridge с названием docker_gwbridge для коммуникации самих Docker daemon.
- **host** - изолирует контейнер до той степени, что к нему можно обращаться только в пределах Docker-хоста. Может использоваться с режимом swarm, при этом overlay драйвер так же будет активен, но это вносит ряд ограничений и вряд ли имеет смысл.
- **none** - отключает все сети. Часто используется в дополнении при описании нестандартных сетей, чтобы отключить все лишнее. Режим не может использоваться с Swarm.
- **macvlan** - позволяет привязать контейнеру MAC-адрес, тем самым позволяет подключиться к физической сети. Рекомендуется для использования с теми приложениями, что требуют прямого доступа к сети. Не может использоваться при описании файла конфигурации Docker Compose. Поддерживает режимы bridge и 802.1q. Можно создать ipvlan, если нужен L2 мост вместо L3.

#### bridge
Используется для коммуникации контейнеров в пределах одного хоста.
По-умолчанию используется мост с названием bridge. Он не рекомендуется для использования в продакшене. Его настройки можно поменять при желании.
Можно сделать свою сеть данного типа и подключать к ней контейнеры. В docker CLI создать сеть можно командой docker network create my-net, а как сделать в Docker Compose будет описано далее.

Различия моста по-умолчанию и определенного пользователем¶
Описанные пользователем контейнеры предоставляет лучшую изоляцию контейнеризированных приложений. Контейнеры, подключенные к пользовательскому мосту открывают все прокинутые порты внутри данного моста друг другу локально, но не в публичную сеть.
Определенные пользователем мосты предоставляют автоматическое разрешение DNS имени между контейнерами. Контейнеры в стандартной сети моста могут обращаться к друг другу только по IP-адресам пока не указан параметр --link (так же поддерживается в Compose, но он признан устаревшим и использовать его больше не рекоммендуется ни в коем случае). В случае с пользовательской сетью типа мост можно обращаться к контейнеру по его имени или заданному alias.
Контейнеры могут быть подключены и отключены от сети пользовательской сети на лету. Это позволяет не пересоздавая контейнер настроить его параметры в сети, например указать другой статический IP-адрес.
Пользовательские мосты могут настраиваться. Пользовательские мосты настраиваются и управляются через docker network create или в Docker Compose файле. Настройки можно менять на лету. У родного моста менять настройки надо изменяя файл конфигурации daemon.json, а так же он использует единые настройки iptables и MTU.
Связанные флагом --link контейнеры в родной сети "мост" делят переменные окружения. Так как после внедрения настраиваемых сетей режим --link устарел и не ркомендуется к использованию, то рассматривать подробности этого пункта смысла не имеет.

#### overlay

Распределенная сеть среди нескольких хостов Docker. Название сети происходит от слова "прослойка" (overlay), потому как потому как сеть является прослойкой для коммуникации контейнеров в распределенной сети.
Сеть типа overlay требует, чтобы хост был частью сети Swarm. В Swarm по умолчанию используется сеть типа overlay с именем ingress для распределения нагрузки, а так же сеть типа bridge с названием docker_gwbridge для коммуникации самих Docker daemon.
Для overlay сетей есть так же требования к фаерволу, то есть открытым в нем портам:

- TCP 2377 для коммуникации менеджмента кластера;
- TCP и UDP 7946 для коммуникации нод кластера;
- UDP 4789 для трафика сети overlay.

У пользовательской overlay сети есть несколько интересных параметров:
--attachable: позволяет общаться не только сервисам, но и отдельным контейнерам с другими контейнерами в пределах swarm;
--opt encrypted: включает шифрование AES в режиме GCM с ротацией ключей каждые 12 часов. К сожалению, так как используется виртуальная LAN (VxLAN), то нагрузка на ЦП сильно возрастает, потому опция может не подходить для продакшена. Windows хосты также не поддерживают опцию.
Для изменения настроек родных сетей ingress и docker_gwbridge их необходимо удалить и создать заново.

#### host
При использовании данного режима сети сетевой стек контейнера не изолирован от хоста Docker. аким образом если контейнер привязывается к 80 порту (например, nginx), то он будет доступен по порту 80 IP-адресу хоста.
При использовании режима в Docker swarm используется overlay сеть для управляющего трафика, а контейнер доступен только с одной машине, к которой привязался. Это создает ограничение, которое не позволяет использовать в swarm на машине с занятым портом приложение. Таким образом если в Swarm используется порт 80 в распределенной сети и на одной машине из swarm есть контейнер с host режимом, то на этой машине не будет доступно приложение из распределенной сети.

#### macvlan/ipvlan

Некоторые приложения, например для мониторинга трафика, должны быть напрямую покдлючены к физической сети. Это можно сделать с помощью режимов macvlan и ipvlan.
Необходимо понимать, что для этого режима используется физический сетевой интерфейс, который имеет доступ к физической сети. Для изоляции от основной сетинеобходимо использовать другой сетевой интерфейс или создать VLAN.
При использовании режима надо понимать, что можно нанести вред своей сети исчерпав запас IP-адресов или необдуманным созданием VLANов;
сетевой интерфейс должен поддерживать использование нескольких MAC-адресов;
если приложение может работать с bridge илиoverlay режимами, то лучше выбрать их.
macvlan может работать в двух режимах:

сетевой мост, где трафик идет через физический адаптер хоста;
сетевой мост с использованием стандарта 802.1Q, где тегируется трафик и показывается принадлежность к определенному VLAN. Docker создает сетевой "подинтерфейс" над основным, позволяя настраивать маршрутизацию и фильтрацию на более высоком уровне.
Если необходим более низкоуровневый чем L3 мост, то можно создать ipvlan.

Конфигурация данного вида сетей недоступна из docker compose.



## Docker Overlay
## TODO: Need investigate!

## Weave
## TODO: Need investigate!


<img src="https://avatars.githubusercontent.com/u/9976052?s=200&v=4" height="100" width="auto" alt="Weave"/>


<img height="400px" width="auto" alt="Weave schema" src="https://www.weave.works/docs/net/latest/weave-net-overview.png" />

## Flannel
## TODO: Need investigate!

https://github.com/flannel-io/flannel

<img src="https://github.com/flannel-io/flannel/raw/master/logos/flannel-horizontal-color.png" height="100" width="auto" alt="Flannel"/>

Flannel runs a small, single binary agent called flanneld on each host, 
and is responsible for allocating a subnet lease to each host out of a larger, preconfigured address space.

Flannel uses either the Kubernetes API or etcd directly to store the network configuration, the allocated subnets,
and any auxiliary data (such as the host's public IP). 

Packets are forwarded using one of several backend mechanisms including VXLAN and various cloud integrations.


## Calico
## TODO: Need investigate!

<img src="https://habrastorage.org/r/w1560/webt/ut/_g/o1/ut_go1ror_jprp6n0bbwthgdkvs.png" alt="Project Calico"  height="100" width="auto"/>