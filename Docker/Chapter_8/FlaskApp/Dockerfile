FROM python:3.10.13
MAINTAINER "Kevin Shindel"
RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi
WORKDIR /opt/app
COPY app .
COPY requirements.txt entrypoint.sh ../
RUN pip install --no-cache-dir -r ../requirements.txt
RUN chmod +x ../entrypoint.sh
EXPOSE 8080 8081
USER uwsgi
ENTRYPOINT ["/opt/entrypoint.sh"]