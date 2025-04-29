pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'yii2-app'
        DOCKER_TAG = 'latest'
        DOCKER_USERNAME = 'pandu321'
        EC2_HOST = 'ubuntu@3.83.246.10'
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker build -t $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_TAG .
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
                        sh """
                            ssh -o StrictHostKeyChecking=no $EC2_HOST '
                                docker pull $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_TAG &&
                                docker stack deploy -c /home/ubuntu/yii2-app/docker-compose.yml yii2app
                            '
                        """
                    }
                }
            }
        }
    }
}

    
