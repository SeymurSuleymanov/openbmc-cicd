# CI/CD для OpenBMC: Jenkins + QEMU + автотесты, WebUI и нагрузочное тестирование

Лабораторная работа № 7. Пайплайн описан в `Jenkinsfile` (Declarative Pipeline, Groovy).

## Стадии пайплайна и артефакты

| Стадия | Что делает | Артефакты |
|--------|------------|-----------|
| Checkout | клонирование репозитория | `artifacts/00-checkout.log` |
| QEMU: запуск OpenBMC | старт `qemu-system-arm -M romulus-bmc`, ожидание Redfish | `artifacts/01-qemu-*.log` |
| Автотесты Redfish API | `pytest test_redfish.py` | `artifacts/02-redfish-junit.xml`, console log |
| WebUI тесты OpenBMC | Selenium (или HTTP-проверки интерфейса) | `artifacts/03-webui-junit.xml`, log |
| Нагрузочное тестирование | Locust, 10 польз., 40 с | `artifacts/04-locust*.csv`, `04-locust-report.html` |

Все стадии публикуют артефакты через `archiveArtifacts`, тестовые — ещё и `junit`.

## Развёртывание Jenkins в Docker

```bash
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk17
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Дальше: New Item -> Pipeline -> Pipeline script from SCM -> Git -> URL репозитория ->
Script Path: `Jenkinsfile`.

## Локальный прогон стадий (без Jenkins)

```bash
bash ci/start_bmc.sh && bash ci/wait_bmc.sh
bash ci/run_autotests.sh
python3 ci/webui_tests.py --junit artifacts/03-webui-junit.xml
bash ci/run_loadtest.sh
bash ci/stop_bmc.sh
```

Переменные: `BMC_URL`, `BMC_USER`, `BMC_PASSWORD`, `OPENBMC_IMAGE`, `TESTS_DIR`.
