#!/bin/bash
set -e
if [[ "$ENV" = "DEV" ]]; then
  echo "[!] RUNNING DEV SERVER"
  exec python flask_serv.py
else
  echo "[!] RUNNING PROD SERVER"
  exec uwsgi --http 0.0.0.0:80 --wsgi-file flask_serv.py --callable app --stats 0.0.0.0:81
fi
