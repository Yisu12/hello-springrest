pipeline {
    agent any
    options{
        timestamps()
        ansiColor('xterm')
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker-compose build'
                sh 'git tag 1.0.${BUILD_NUMBER}'
                sh 'docker tag ghcr.io/yisu12/hello-springrest:latest ghcr.io/yisu12/hello-springrest:1.0.${BUILD_NUMBER}'
                sshagent(['git2']) {
                    sh 'git push --tags'
                }
            }
        }
        stage('Package') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'CR_PAT')]) {
                    sh 'echo $CR_PAT | docker login ghcr.io -u yisu12 --password-stdin'
                    sh "docker push ghcr.io/yisu12/hello-springrest:1.0.${BUILD_NUMBER}"
                    sh "docker push ghcr.io/yisu12/hello-springrest:latest"
                }
            }
        }
        stage('Deploy') {
            steps {
                withAWS(credentials: 'aws-credentials', region: 'eu-west-1') {
                    dir('eb'){
                        sh 'eb deploy'
                    }
                }
            }
        }
    }
}
