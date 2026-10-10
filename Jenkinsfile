pipeline {
    agent any
    options { timestamps(); disableConcurrentBuilds() }
    environment {
        BMC_URL      = 'https://127.0.0.1:2443'
        BMC_USER     = 'root'
        BMC_PASSWORD = '0penBmc'
        ART          = 'artifacts'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'mkdir -p $ART && git rev-parse --short HEAD | tee $ART/00-checkout.log'
            }
            post { always { archiveArtifacts artifacts: "$ART/00-*.log", allowEmptyArchive: true } }
        }
        stage('QEMU: запуск OpenBMC') {
            steps {
                sh 'bash ci/start_bmc.sh 2>&1 | tee $ART/01-qemu-start.log'
                sh 'bash ci/wait_bmc.sh  2>&1 | tee $ART/01-qemu-ready.log'
            }
            post { always { archiveArtifacts artifacts: "$ART/01-*.log", allowEmptyArchive: true } }
        }
        stage('Автотесты Redfish API') {
            steps { sh 'bash ci/run_autotests.sh 2>&1 | tee $ART/02-autotests.log' }
            post {
                always {
                    junit testResults: "$ART/02-redfish-junit.xml", allowEmptyResults: true
                    archiveArtifacts artifacts: "$ART/02-*", allowEmptyArchive: true
                }
            }
        }
        stage('WebUI тесты OpenBMC') {
            steps { sh 'python3 ci/webui_tests.py --junit $ART/03-webui-junit.xml 2>&1 | tee $ART/03-webui.log' }
            post {
                always {
                    junit testResults: "$ART/03-webui-junit.xml", allowEmptyResults: true
                    archiveArtifacts artifacts: "$ART/03-*", allowEmptyArchive: true
                }
            }
        }
        stage('Нагрузочное тестирование') {
            steps { sh 'bash ci/run_loadtest.sh 2>&1 | tee $ART/04-loadtest.log' }
            post { always { archiveArtifacts artifacts: "$ART/04-*", allowEmptyArchive: true } }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: "$ART/**/*", allowEmptyArchive: true
            sh 'bash ci/stop_bmc.sh || true'
        }
    }
}
