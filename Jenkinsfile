pipeline {
    agent {
        docker {
            image 'example:v1.0'
            args '-v ${WORKSPACE}:/workspace'
        }
    }
    tools {
        allure 'allure_2.34.1'
    }
    stages {
        stage('Setup') {
            steps {
                sh 'pip install --force-reinstall .'
                sh 'nohup python test/utils/mock_server.py &'
            }
        }
        stage('Test') {
            steps {
                sh 'cd test && python main.py'
            }
            post {
                always {
                    allure([
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'test/cache']]
                    ])
                }
            }
        }
    }
}