pipeline {
    agent {
        docker {
            image 'example:v1.0'
            args '-v ${WORKSPACE}:/workspace'
        }
    }
    environment {
        // 使用 Secret text 类型的凭据
        GITHUB_TOKEN = credentials('GitHub-Token')
        // 获取 Git 提交 SHA
        GIT_COMMIT = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
        // GitHub 仓库路径（避免硬编码）
        GITHUB_REPO = sh(
            script: 'git remote -v | head -n1 | awk \'{print $2}\' | sed \'s|git@github.com:||; s|https://github.com/||; s|.git$||\'',
            returnStdout: true
        ).trim()
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
                    
                    script {
                        def testResult = currentBuild.currentResult
                        def resultEmoji = testResult == 'SUCCESS' ? '✅' : '❌'
                        def resultText = testResult == 'SUCCESS' ? '通过' : '失败'
                        
                        // 构建评论内容（使用单引号避免变量插值）
                        def comment = """${resultEmoji} Jenkins 测试${resultText}\n构建详情: ${env.BUILD_URL}\nAllure 报告: ${env.BUILD_URL}allure/"""
                        
                        // 使用临时文件存储JSON数据
                        writeFile file: 'comment.json', text: groovy.json.JsonOutput.toJson([body: comment])

                        sh '''#!/bin/bash
                            curl -s -X POST \\
                            -H "Authorization: token ${GITHUB_TOKEN}" \\
                            -H "Accept: application/vnd.github.v3+json" \\
                            -H "Content-Type: application/json" \\
                            "https://api.github.com/repos/${GITHUB_REPO}/commits/${GIT_COMMIT}/comments" \\
                            --data-binary @comment.json
                         '''
                    }
                }
            }
        }
    }
}
