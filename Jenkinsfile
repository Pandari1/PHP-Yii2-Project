pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/yii2-app"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install PHP and Composer') {
            steps {
                sh '''
                    sudo apt update
                    sudo apt install -y php php-cli unzip curl php-mbstring php-xml php-dom php-xsl
                    curl -sS https://getcomposer.org/installer | php
                    sudo mv composer.phar /usr/local/bin/composer
                '''
            }
        }

        stage('Install Composer Dependencies') {
            steps {
                dir('src') {
                    sh 'composer install --no-interaction --prefer-dist --optimize-autoloader'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                sh '''
                    docker build -t $DOCKER_IMAGE ./src
                    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                    docker push $DOCKER_IMAGE
                '''
            }
        }

        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }
    }
}
    
