// // when a new push happens, 
// 1. trigger a docker build
// 2. push image to aws ecr
// 3. finally deploy as a task.

pipeline{
    agent any
    stages{
        stage('docker build'){
            steps{
                echo "stating docker build"
                sh "docker build -t node-test-01:latest ."
                sh "docker images"
            }
        }
        stage('docker run'){
            steps{
                echo "time to run docker image"
                echo "done"
            }
        }
        stage('uploading image to AWS ECR'){
            steps{
                sh "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c5d4m2m5"
                sh "docker build -t nodejs/sserver ."
                sh "docker tag nodejs/sserver:latest public.ecr.aws/c5d4m2m5/nodejs/sserver:latest"
                sh "docker push public.ecr.aws/c5d4m2m5/nodejs/sserver:latest"
                echo " done"
            }
        }
    }

}