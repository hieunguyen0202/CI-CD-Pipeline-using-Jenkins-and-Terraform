# CI-CD-Pipeline-using-Jenkins-and-Terraform
## Architecture diagram 

![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/27c0e4ea-d731-4d1f-9768-f2d0ca3daae7)

## Step-by-step 

## Implementation
### Setup project on Google Cloud Platform
- Go to [GCP platform](https://console.cloud.google.com/welcome?hl=vi&project=festive-flame-414810)
- Create new project with name `ci-cd-jenkins-terraform`
- Remember to set up billing account for this project

### Setup Jenkin fron marketplace
- Search for `jenkin`

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/fc111635-de04-4975-bf0c-043bf5ed821c)

- Click `get started` with jenkins and deploy jenkins with virtual machine

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/46f268ce-ebd3-4c3c-b2e7-5c085d79a77f)

- Make sure to enable API for some services like this

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/7ba0e0d9-da26-4c6d-bff4-c6f1b4f2b57f)

- Next, you should fill some infomation to configure jenkins on VM instance
  - Give a name `jenkins-vm`
  - Choose zone `us-central1-a` or give any zone that you like
  - Allow for firewall rules

    ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/d77407c7-2484-46fa-b2d6-e2590ff982dd)

  - Everything else left by default
  - Click on `Deploy` and wait some times to complete and go to next step

### Setup UI jenkins
- Go to the [VM instance](https://console.cloud.google.com/compute/instances?hl=vi&project=ci-cd-jenkins-terraform) and copy this `URL external IP` and go to the Jenkins

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/df08b582-ee4c-4704-942d-4c590e2fb7bc)

- Copy this username and password in `Deployment manager`-> Click `jenkins-vm`

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/8cf52e57-3b28-4b85-ad9c-a8b8aa3171ff)

- You need to install some plugins `Pipeline` `Pipeline:API` `Pipeline: SCM Step` `Pipeline: Job` `Pipeline: Groovy` `Pipeline: Statge View` (Go to Manage Jekins -> Plugins -> Available plugins)

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/1f49a9a4-7e1e-4962-b9aa-1059141f0aad)

- Wait for seconds and restart the Jenkins machine

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/cbaf0872-b791-4e2b-ba7e-b7d989129a0f)

- Type username and password again and check some plugins installed

### Install terraform in Jenkins machine
- Go back to [VM instance](https://console.cloud.google.com/compute/instances?hl=vi&project=ci-cd-jenkins-terraform) dashboard and click on `SSH`
- Do some command line to install terraform

  ```
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

  # Install the HashiCorp GPG key

  wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

  # Verify the key's fingerprint

  gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

  # Add the official HashiCorp repository to your system. The lsb_release -cs command finds the distribution release codename for your current system, such as buster, groovy, or sid.

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

  # Download the package information from HashiCorp
  
  sudo apt update

  # Install Terraform from the new repository

  sudo apt-get install terraform

  # Check terraform version

  sudo apt-get install terraform

  ```

- Verify that

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/28cf697e-2aa7-47a8-8db9-0a450aa46d1d)

- Next, install some more plugins for `git` `github` and make sure to restart the jenkins server and login again

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/264c1413-3587-460b-a191-a760aff1a923)

### Create github repository and setup credentail on Jenkins
- Create private repository with name `gcp-tf-jenkins`
- Create some file `main.tf` and `Jenkinsfile`

```tf
resource "google_storage_bucket" "my-bucket" {
  name                     = "githubdemo-bucket-001"
  project                  = "ci-cd-jenkins-terraform"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}
```

```yaml
pipeline {
    agent any
	
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key')
	GIT_TOKEN = credentials('git-token')
    }
	
    stages {
        stage('Git Checkout') {
            steps {
               git "https://${GIT_TOKEN}@github.com/vishal-bulbule/gcp-tf-jenkin.git"
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
```


  




  

  

  

  

  
 
  


  
