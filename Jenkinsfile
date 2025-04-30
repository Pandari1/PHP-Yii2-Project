pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'yii2-app'
        DOCKER_TAG = 'latest'
        DOCKER_USERNAME = 'pandu321'
        EC2_HOST = 'ubuntu@3.93.148.126'
    }

    options {
        timestamps()
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Composer') {
            steps {
                script {
                    // Install Composer if not installed
                    sh '''
                    curl -sS https://getcomposer.org/installer | php
                    sudo mv composer.phar /usr/local/bin/composer
                    '''
                }
            }
        }

        stage('Install Composer Dependencies') {
            steps {
                script {
                    // Navigate to the src directory and install dependencies
                    sh '''
                    cd src && composer install --no-interaction --prefer-dist --optimize-autoloader
                    '''
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker build -t pandu321/yii2-app:latest -f src/Dockerfile src/
                        docker push $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_TAG
                        docker logout
                        '''
                    }
                }
            }
        }

        stage('Deploy on EC2 via SSH') {
            steps {
                script {
                    sshagent(['ec2-ssh-key']) {
                        sh '''
                            ssh -o StrictHostKeyChecking=no $EC2_HOST ' << EOF
                            set -e
                            docker pull $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_TAG &&
                            docker stack rm yii2app || true
                            sleep 10
                            rm -rf ~/yii2-app
                            git clone https://github.com/Pandari1/PHP-Yii2-Project.git ~/yii2-app
                            cd ~/yii2-app
                            docker stack deploy -c docker-compose.yml yii2app
EOF
                        '''
                    }
                }
            }
        }
    }
}
    
