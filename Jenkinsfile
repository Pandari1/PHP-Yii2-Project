pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'pandu321/yii2-app'
        PROJECT_DIR = 'src'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate composer.lock') {
            steps {
                script {
                    // Check if composer.lock exists
                    if (fileExists("${env.PROJECT_DIR}/composer.lock")) {
                        // Check if the composer.lock file is valid JSON
                        def composerLockFile = readFile("${env.PROJECT_DIR}/composer.lock")
                        try {
                            // Try to parse the file to validate it
                            def json = readJSON text: composerLockFile
                        } catch (Exception e) {
                            // If it's invalid, remove it and recreate
                            echo 'Invalid composer.lock file, regenerating it.'
                            sh "rm ${env.PROJECT_DIR}/composer.lock"
                        }
                    }
                }
            }
        }

        stage('Install PHP Dependencies') {
            steps {
                dir("${env.PROJECT_DIR}") {
                    sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:latest ${PROJECT_DIR}"
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
    }
}
