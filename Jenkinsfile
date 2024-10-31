pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jiruk/keduitlab:purple'         // Docker 이미지 이름
        ANSIBLE_INVENTORY = '/root/inventory.ini'        // Ansible 인벤토리 파일 경로
        ANSIBLE_HOST = '211.183.3.199'                   // Ansible 서버 IP 주소
        SSH_KEY_PATH = '~/.ssh/id_rsa'                   // Jenkins 서버의 프라이빗 키 경로
        MASTER_NODE = '211.183.3.100'                    // Kubernetes 마스터 노드
        WORKER_NODES = '211.183.3.101 211.183.3.102 211.183.3.103' // Kubernetes 워커 노드들
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
                    sudo docker build -t jiruk/keduitlab:purple .
                    sudo docker push jiruk/keduitlab:purple
                    '''
                }
            }
        }

        stage('Deploy Docker Image to Worker Nodes via Ansible') {
            steps {
                script {
                    // SSH를 통해 Ansible 서버에 접속하여 각 워커 노드에서 Docker 이미지 배포 플레이북을 실행합니다.
                    for (node in "${WORKER_NODES}".split()) {
                        sh """
                        ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no jenkins@${ANISBLE_HOST} \\
                        "ansible-playbook -i /root/inventory.ini -l ${node} /path/to/deploy_docker_image.yml"
                        """
                    }
                }
            }
        }

        stage('Kubernetes Deployment and Expose via Ansible') {
            steps {
                script {
                    // SSH를 통해 Ansible 서버에 접속하여 마스터 노드에서 Kubernetes 배포 플레이북을 실행합니다.
                    sh """
                    ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no jenkins@${ANISBLE_HOST} \\
                    "ansible-playbook -i /root/inventory.ini -l ${MASTER_NODE} /path/to/deploy_k8s.yml"
                    """
                    """
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
