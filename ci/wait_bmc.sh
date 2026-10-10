#!/usr/bin/env bash
# Ожидание готовности Redfish API
URL="${BMC_URL:-https://127.0.0.1:2443}"
for i in $(seq 1 60); do
  CODE=$(curl -sk -m 3 -o /dev/null -w '%{http_code}' -u "${BMC_USER:-root}:${BMC_PASSWORD:-0penBmc}" "$URL/redfish/v1/")
  if [ "$CODE" = "200" ]; then echo "OpenBMC готов: HTTP $CODE (через ~$((i*3)) с)"; exit 0; fi
  sleep 3
done
echo "OpenBMC не поднялся"; exit 1
