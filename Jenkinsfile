pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'dockerhub-cred'
        DOCKER_HUB_USER = 'meddhiaalaya'
        IMAGE_NAME = 'student-management-app'
        SONARQUBE_URL = 'http://192.168.33.10:9000/'
        SONAR_PROJECT_KEY = 'student-management'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/medDhiaAlaya/student-managment.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarcube-cred', variable: 'SONAR_TOKEN')]) {
                    sh '''
                    /opt/sonar-scanner-6.0.0.4432-linux/bin/sonar-scanner \
                      -Dsonar.projectKey=student-management \
                      -Dsonar.sources=src \
                      -Dsonar.java.binaries=target/classes \
                      -Dsonar.host.url=http://192.168.33.10:9000 \
                      -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }


        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    def commitHash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${commitHash} ."
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${commitHash}
                        docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:${commitHash} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
                        docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
                        docker logout
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -f'
        }
        success {
            echo '✅ Pipeline executed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
