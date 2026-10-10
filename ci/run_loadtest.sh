#!/usr/bin/env bash
# Нагрузочное тестирование: 10 пользователей, 40 секунд, отчёты в artifacts/
ART="${ART:-artifacts}"
cd "$(dirname "$0")/.." || exit 1
python3 -m locust -f ci/locustfile.py --headless -u 10 -r 2 -t 40s \
  --csv "$ART/04-locust" --html "$ART/04-locust-report.html" --only-summary 2>&1 | tail -20
