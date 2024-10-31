pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jiruk/keduitlab:purple'  // Docker 이미지 이름 수정
        ANSIBLE_INVENTORY = '/root/inventory.ini' // Ansible 인벤토리 파일 경로
    }

    stages {
        stage('Git SCM Update') {
            steps {
                // GitHub에서 소스를 클론합니다.
                git url: 'https://github.com/jinwuk97/jenkinstest.git', branch: 'master'
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    // Docker 이미지를 빌드하고, Docker Hub에 푸시합니다.
                    sh '''
                    sudo docker build -t jiruk/keduitlab:purple
                    sudo docker push jiruk/keduitlab:purple
                    '''
                }
            }
        }

        stage('Deploy Docker Image to Worker Nodes via Ansible') {
            steps {
                script {
                    // Ansible 플레이북을 실행하여 각 워커 노드에서 Docker 이미지를 당겨옵니다.
                    sh "ansible-playbook -i /root/inventory.ini deploy_docker_image.yml"
                }
            }
        }

        stage('Kubernetes Deployment and Expose via Ansible') {
            steps {
                script {
                    // Ansible 플레이북을 실행하여 마스터 노드에서 Kubernetes 배포 및 노출을 처리합니다.
                    sh "ansible-playbook -i /root/inventory.ini deploy_k8s.yml"
                }
            }
        }
    }

    post {
        always {
            // 파이프라인 실행 후 작업 디렉터리를 정리합니다.
            cleanWs()
        }
    }
}
