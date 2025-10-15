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

        stage('Run Container') {
            steps {
                script {
                    sh '''
                    # Stop and remove previous container if exists
                    docker rm -f app-container || true

                    # Run new container mapping container port 8080 to host port 9090
                    docker run -d --name app-container -p 9090:8080 snehadhage96/aws-repo:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully. App is running on http://<your-server>:9090"
        }
        failure {
            echo "❌ Build or deployment failed."
        }
    }
}


