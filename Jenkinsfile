pipeline {
  agent any
  stages {
    stage('git scm update') {
      steps {
        git url: 'https://github.com/jinwuk97/jenkinstest.git', branch: 'main'
      }
    }
    stage('docker build and push') {
      steps {
        sh '''
        sudo docker build -t jiruk/keduit:purple
        sudo docker push jiruk/keduit:purple
        '''
      }
    }
    stage('deploy and service') {
      steps {
        sh '''
        sudo kubectl apply -f /root/kenkins.yml
        '''
      }
    }
  }
}
