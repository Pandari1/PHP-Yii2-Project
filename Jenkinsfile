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
                            sh 'docker build -t $DOCKER_IMAGE_NAME ./src'
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
                            ssh -o StrictHostKeyChecking=no $EC2_HOST ' << EOF
                            set -e
                            docker pull $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_TAG &&
                            # Optional: remove existing stack or service
                            docker stack rm yii2app || true
                            sleep 10  # allow time to remove stack

                            # Clone latest code and deploy stack
                            rm -rf ~/yii2-app
                            git clone https://github.com/Pandari1/PHP-Yii2-Project.git ~/yii2-app
                            cd ~/yii2-app 
                            docker stack deploy -c docker-compose.yml yii2app
EOF
                """
                    }
                }
            }
        }
    }
}

    
