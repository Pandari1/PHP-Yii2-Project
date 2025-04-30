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
                // Clean the workspace before starting the build
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install PHP and Composer') {
            steps {
                script {
                    // Install PHP and Composer dependencies if not installed
                    sh '''
                    # Install PHP and Composer if not installed
                    sudo apt update
                    sudo apt install -y php-cli php-mbstring unzip curl

                    # Download and install Composer
                    curl -sS https://getcomposer.org/installer | php
                    sudo mv composer.phar /usr/local/bin/composer
                    '''
                }
            }
        }

        stage('Clean Composer Files') {
            steps {
                script {
                    // Clean up composer.lock and vendor directory before running composer install
                    sh '''
                    rm -f src/composer.lock
                    rm -rf src/vendor
                    '''
                }
            }
        }

        stage('Install Composer Dependencies') {
            steps {
                script {
                    // Ensure we're in the correct directory where composer.json is located
                    sh 'cd src && composer install --no-interaction --prefer-dist --optimize-autoloader'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Pull DockerHub credentials securely
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Log in to DockerHub
                        sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        '''
                        // Build Docker Image using the Dockerfile and tag it
                        sh """
                        docker build -t $DOCKER_USERNAME/yii2-app:$DOCKER_TAG -f src/Dockerfile src/
                        """
                        // Push the Docker image to Docker Hub
                        sh """
                        docker push $DOCKER_USERNAME/yii2-app:$DOCKER_TAG
                        """
                        // Log out from DockerHub after pushing the image
                        sh '''
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
    
