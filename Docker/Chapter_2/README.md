# Docker install by script
```shell
curl --request GET -sL \
     --url 'https;//get.docker.com'\
     --output '/tmp/install'
cat /tmp/install
chmod +x /tmp/install.sh
/tmp/install.sh
```
# Launch docker w-out sudo
```shell
sudo usermod -aG docker
sudo service docker restart
```
# Docker version check
```shell
docker version
```