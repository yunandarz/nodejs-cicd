def remote = [:]
remote.name = "yunandar-app"
remote.host = "103.117.56.235"
remote.allowAnyHosts = true

pipeline {
    agent any
    environment {
                DOCKER_CRED = credentials('dockerhub-yunandar711')
            }
    stages {
        stage('Build image') {
            steps {
                    sh 'docker build -t nodejs-app:${GIT_BRANCH} .'
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
        stage('Deploy to server') {
            environment {
                APP_CRED = credentials('VM-APP')
            }
            steps {
                script {
                    remote.user=env.APP_CRED_USR
                    remote.password=env.APP_CRED_PSW
                }
                sshCommand remote: remote, command: 'docker run yunandar711/nodejs-app:${GIT_BRANCH}'
            }
        }
    }
//    post {
//      always {
//          sh 'echo('complete')''
       // sh 'docker rm -f yunandar711/nodejs-app:${GIT_BRANCH} && docker logout'
//    }
//  }
}
