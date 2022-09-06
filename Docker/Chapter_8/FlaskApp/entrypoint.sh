#!/bin/bash
set -e
if [[ "$ENV" = "DEV" ]]; then
  echo "[!] RUNNING DEV SERVER"
  exec python app.py
elif [[ "$ENV" = "TEST" ]]; then
    echo "[!] RUNNING TESTS"
    exec python tests.py
else
  echo "[!] RUNNING PROD SERVER"
  exec uwsgi --http 0.0.0.0:8080 --wsgi-file app.py --callable app --stats 0.0.0.0:8081
fi
