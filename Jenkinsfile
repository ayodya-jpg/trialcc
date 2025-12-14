pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t flixplay-app .'
            }
        }

        stage('Test') {
            steps {
                bat 'docker run --rm flixplay-app php artisan --version'
            }
        }

        stage('Deploy to Azure') {
            steps {
                bat '''
                az webapp restart \
                  --name flixplay-app \
                  --resource-group rg-flixplay
                '''
            }
        }
    }
}
