
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'snehadhage96/aws-repo'
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
                    // Assign to global dockerImage variable
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_creds') {
                        dockerImage.push()
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "❌ Build or deployment failed."
        }
        success {
            echo "✅ Build and push successful."
        }
    }
}

