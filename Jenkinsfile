pipeline {
    agent any

    environment {
        // === ENV CONFIG ===
        DOCKER_HUB_CREDENTIALS = 'dockerhub-cred'  // Jenkins credentials ID
        DOCKER_HUB_USER = 'meddhiaalaya'
        IMAGE_NAME = 'student-management-app'
        SONARQUBE_URL = 'http://192.168.33.10:9000/'  // e.g. http://192.168.56.101:9000
        SONAR_PROJECT_KEY = 'sonarcube-cred'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/medDhiaAlaya/student-managment.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package -DskipTests=false'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarcube-cred', variable: 'SONAR_TOKEN')]) {
                    sh """
                    sonar-scanner \
                      -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                      -Dsonar.sources=src \
                      -Dsonar.host.url=${SONARQUBE_URL} \
                      -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                    echo $PASSWORD | docker login -u $USERNAME --password-stdin
                    docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
                    docker logout
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully: build, SonarQube analysis, and Docker push complete!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
