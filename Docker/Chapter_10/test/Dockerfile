FROM logstash:6.4.0
ADD logstash.conf /usr/share/logstash/config
ADD logstash.yml /usr/share/logstash/config
CMD logstash -f /usr/share/logstash/config/logstash.conf