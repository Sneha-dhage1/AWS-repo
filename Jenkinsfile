pipeline {

    agent any

    environment {
        DOCKER_IMAGE = "sneha123/sample-app:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                dir('aws-app') { // Adjust this if your pom.xml is in a different directory
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, 'aws-app') // build the Docker image from the 'aws-app' folder
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Stop and remove old container if exists
                    sh 'docker rm -f sample-app || true'

                    // Run new container
                    sh "docker run -d -p 9090:8080 --name sample-app ${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Build and deployment successful!'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}

