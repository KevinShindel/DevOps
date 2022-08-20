# use debian image and wheezy modification
FROM debian:jessie
# after launch image run commans
RUN apt-get update && apt-get install cowsay fortune -y
# copy script into docker container
COPY cowsay/entrypoint.sh .
# run script
ENTRYPOINT ["/entrypoin.sh"]