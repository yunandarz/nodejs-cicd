pipeline {
    agent any
    environment {
                DOCKER_CRED = credentials('dockerhub-yunandar711')
            }
            
    stages {
        stage('Build image') {
            steps {
                    sh 'docker build -t yunandar711/nodejs-app:${GIT_BRANCH} .'
                    sh 'docker images'
                }
        }

        stage('Push Dockerhub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-yunandar711', usernameVariable: 'DOCKER_CRED_USR', passwordVariable: 'DOCKER_CRED_PSW')]) { 
                    sh 'docker login -u ${DOCKER_CRED_USR} -p ${DOCKER_CRED_PSW}' 
                    sh 'docker push yunandar711/nodejs-app:${GIT_BRANCH}' }
                }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    def nodeJS = 'yunandar711/nodejs-app:${GIT_BRANCH}'
                    def stopContainer = "docker stop ${nodeJS}"
                    def deleteContName = "docker rm ${nodeJS}"
                    def deleteImages = 'docker image prune -a --force'
                    def dockerRun = "docker run -d -p 3000:3000 yunandar711/nodejs-app:${GIT_BRANCH}"
                    println "${dockerRun}"
                    sshagent(['VM-APP']) {
                        sh returnStatus: true, script: "ssh -o StrictHostKeyChecking=no yunandar-app@103.117.56.235 ${stopContainer} "
                        sh returnStatus: true, script: "ssh -o StrictHostKeyChecking=no yunandar-app@103.117.56.235 ${deleteContName}"
                        sh returnStatus: true, script: "ssh -o StrictHostKeyChecking=no yunandar-app@103.117.56.235 ${deleteImages}"

                    // Run the container
                        sh "ssh -o StrictHostKeyChecking=no yunandar-app@103.117.56.235 ${dockerRun}"
                    }
                }
            }
        }

        
    }
    post {
        always {
            sh 'echo(complete)'
            sh 'docker image prune -a --force'
        }
    }
}
