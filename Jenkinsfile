pipeline {
    agent any

    environment {
        ZIP_NAME = "deploy.zip"
        AZURE_SITE = "flixplay-app"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare ZIP (Windows)') {
            steps {
                bat '''
                if exist deploy.zip del deploy.zip
                powershell -Command "Compress-Archive -Path * -DestinationPath deploy.zip -Force"
                '''
            }
        }

        stage('Deploy to Azure (Zip Deploy)') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'azure-zip-deploy',
                    usernameVariable: 'AZ_USER',
                    passwordVariable: 'AZ_PASS'
                )]) {
                    bat '''
                    curl -X POST ^
                      -u %AZ_USER%:%AZ_PASS% ^
                      https://flixplay-app.scm.azurewebsites.net/api/zipdeploy ^
                      --data-binary @deploy.zip
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment sukses ke Azure App Service"
        }
        failure {
            echo "❌ Deployment gagal"
        }
    }
}
