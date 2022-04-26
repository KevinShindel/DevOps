FROM ubuntu:16.04
RUN apt-get update
RUN apt-get -y install apache2
RUN echo "Hello world, from docker" > /var/www/html/index.html
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80