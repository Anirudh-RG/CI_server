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
                sh "docker run -d -p 3000:3000 node-test-01:latest"
                echo "done"
            }
        }
    }

}