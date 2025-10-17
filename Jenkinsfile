pipeline {
    agent any

    environment {
        IMAGE_NAME = 'snehadhage96/simple-app'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Build JAR with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        dockerImage.push()
                    }
                }
            }
        }

        // ✅ Added Deploy Stage
        stage('Deploy to Server') {
            steps {
                sshagent(['server-ssh-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@<your-server-ip> '
                            docker pull snehadhage96/simple-app:latest &&
                            docker stop simple-app || true &&
                            docker rm simple-app || true &&
                            docker run -d -p 8080:8080 --name simple-app snehadhage96/simple-app:latest
                        '
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build, Push, and Deployment succeeded!'
        }
        failure {
            echo '❌ Pipeline failed. Please check logs.'
        }
    }
}

