pipeline {
    agent any
    
    stages {
        stage('Docker Build') {
            steps {
                echo "Starting docker build"
                sh "docker build -t node-test-01:latest ."
                sh "docker images"
            }
        }
        stage('Upload to AWS ECR') {
            environment {
                AWS_CREDENTIALS = credentials('aws-creds')
            }
            steps {
                // Login to ECR using credentials stored in Jenkins
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                  credentialsId: 'aws-ecr-credentials',
                                  accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c5d4m2m5"
                    sh "docker tag node-test-01:latest public.ecr.aws/c5d4m2m5/nodejs/sserver:latest"
                    sh "docker push public.ecr.aws/c5d4m2m5/nodejs/sserver:latest"
                }
                echo "Done"
            }
        }
        stage('Docker Run') {
            steps {
                echo "Time to run docker image"
                echo "Done"
            }
        }
    }
}