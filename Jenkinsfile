pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "snehadhage96/aws-repo:latest"  // Updated to your DockerHub repo/image
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Workspace') {
            steps {
                sh 'pwd'
                sh 'ls -l'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -lh target/*.jar || echo "Jar not found!"'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_creds') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh 'docker rm -f aws-repo || true'  // container name updated
                    sh "docker run -d -p 9090:8080 --name aws-repo ${DOCKER_IMAGE}"  // container name updated
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
