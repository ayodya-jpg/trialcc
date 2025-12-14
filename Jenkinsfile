pipeline {
    agent any

    environment {
        APP_NAME = "flixplay-app"
        ZIP_NAME = "deploy.zip"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare App') {
            steps {
                bat '''
                rm -rf vendor node_modules
                zip -r $ZIP_NAME . -x "*.git*" "node_modules/*"
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
                    curl -X POST \
                      -u $AZ_USER:$AZ_PASS \
                      https://flixplay-app.scm.azurewebsites.net/api/zipdeploy \
                      --data-binary @$ZIP_NAME
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
