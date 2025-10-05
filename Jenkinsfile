pipeline {
    agent any



    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/medDhiaAlaya/student-managment.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean install'
            }
        }


    }

    post {
        success {
            echo '✅ Pipeline executed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
