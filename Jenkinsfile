def remote = [:]
remote.name = "yunandar-app"
remote.host = "103.117.56.235"
remote.allowAnyHosts = true

// Delete branch name from origin/main to main only
def branchName = env.GIT_BRANCH.replaceFirst('origin/', '')
sh "docker build -t yunandar711/nodejs-app:${branchName} ."

pipeline {
    agent any
    environment {
                DOCKER_CRED = credentials('dockerhub-yunandar711')
            }
    stages {
        stage('Login Docker') {
            steps {
                 withCredentials([usernamePassword(credentialsId: 'dockerhub-yunandar711', usernameVariable: 'DOCKER_CRED_USR', passwordVariable: 'DOCKER_CRED_PSW')]) { 
                    sh 'docker login -u ${DOCKER_CRED_USR} -p ${DOCKER_CRED_PSW}' }
            }
        }
        stage('Build image') {
            steps {
                    sh 'docker build -t nodejs-app:${branchName} .'
                }
        }
        stage('Push Dockerhub') {
            steps {
                    sh 'docker push yunandar711/nodejs-app:${branchName}}'
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
                sshCommand remote: remote, command: 'docker run yunandar711/nodejs-app:${branchName}'
            }
        }
    }
//    post {
//      always {
//          sh 'echo('complete')''
       // sh 'docker rm -f yunandar711/nodejs-app:${branchName} && docker logout'
//    }
//  }
}
