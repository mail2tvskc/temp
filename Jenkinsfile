pipeline {
    agent {
        kubernetes {
            defaultContainer "shell"
            yamlFile "pod-template.yml"
            
        }
    }
    stages {
        stage('Main') {
            steps {
                sh '''
                    hostname
                    echo "Hi, How are you ?"
                    pwd
                '''
            }
        }
    }
}
