FROM python:3.9
RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi

WORKDIR /opt/app

COPY app .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80
USER uwsgi

#VOLUME /home/username/Projects/DevOps/Docker/Chapter_5/app:/app

CMD ["python", "flask_serv.py"]

#CMD ["uwsgi", "--http", "0.0.0.0:80", "--wsgi-file", "flask_serv.py", "--callable", "app", "--stats", "0.0.0.0:81"]