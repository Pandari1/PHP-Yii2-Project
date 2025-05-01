pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'yii2-app'
        PROJECT_DIR = 'src'
        DOCKERHUB_USERNAME = 'pandu321'
        // Update this to point to the new EC2 host
        EC2_HOST = 'ubuntu@3.93.148.126'  // e.g., 'ubuntu@3.83.246.11'
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
                    // Check if composer.lock exists and is valid
                    if (fileExists("${env.PROJECT_DIR}/composer.lock")) {
                        def isValid = sh(script: "jq empty ${env.PROJECT_DIR}/composer.lock", returnStatus: true)
                        if (isValid != 0) {
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
                    // Install dependencies from composer.json
                    sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('src') {
                    // Build Docker image for the application
                    sh "docker build -t ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:latest -f Dockerfile ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to DockerHub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USERNAME --password-stdin"
                        sh "docker push ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy on EC2 via SSH') {
            steps {
                script {
                    sshagent(['ec2-ssh-key']) {
                        sh '''#!/bin/bash
ssh -o StrictHostKeyChecking=no ${EC2_HOST} <<EOF
set -e
echo "Pulling latest Docker image..."
docker pull ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:latest
echo "Removing existing Docker stack..."
docker stack rm yii2app || true
sleep 10
echo "Cloning latest code..."
rm -rf ~/yii2-app
git clone https://github.com/Pandari1/PHP-Yii2-Project.git ~/yii2-app
echo "Deploying Docker stack..."
cd ~/yii2-app
docker stack deploy -c docker-compose.yml yii2app
EOF
                        '''
                    }
                }
            }
        }

        stage('Cleanup Workspace') {
            steps {
                cleanWs()  // Clean up the workspace after the job is done
            }
        }
    }
}
