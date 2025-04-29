pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'yii2-app' // Docker image name
        DOCKER_TAG = 'latest'  // Docker tag (you can use dynamic tags  well)
        DOCKER_USERNAME = 'pandu321'
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

        stage('Build and Push image') {
            steps {
                script {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker build -t $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:latest .
                            docker push $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:latest
                            docker logout
                            '''
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $EC2_HOST '
                        docker pull pandu321/yii2-app:latest &&
                        docker stack deploy -c /home/ubuntu/yii2-app/docker-compose.yml yii2app
                    '
                    """
                }
            }
        }
    }
}

    
