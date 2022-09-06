FROM python:3.9
MAINTAINER "Kevin Shindel"
RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi
WORKDIR /opt/app
COPY app .
COPY entrypoint.sh ../
COPY requirements.txt ../
RUN pip install --no-cache-dir -r ../requirements.txt
RUN chmod +x ../entrypoint.sh
EXPOSE 8080 8081
USER uwsgi
ENTRYPOINT ["/opt/entrypoint.sh"]