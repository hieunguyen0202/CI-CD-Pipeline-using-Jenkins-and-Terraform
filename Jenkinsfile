pipeline {
    agent any
	
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key-1')
	GIT_TOKEN = credentials('git-token')
    }
	
    stages {
        stage('Git Checkout') {
            steps {
               git "https://${GIT_TOKEN}@github.com/hieunguyen0202/gcp-tf-jenkins.git"
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

	    stage('Manual Approval') {
            steps {
                input "Approve?"
            }
        }
	    
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply tfplan'
                }
            }
        }
    }
}
