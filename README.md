# CI-CD-Pipeline-using-Jenkins-and-Terraform
## Architecture diagram 

![BreadcrumbsCI-CD-Pipeline-using-Jenkins-and-Terraform drawio](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/88cd068e-5097-41c7-a446-8816ac29fba7)


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
# main.tf
resource "google_storage_bucket" "my-bucket" {
  name                     = "githubdemo-bucket-001"
  project                  = "ci-cd-jenkins-terraform"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}
```

```yaml
# Jenkinsfile
pipeline {
    agent any
	
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key')
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
```

- Create [service account](https://console.cloud.google.com/iam-admin/serviceaccounts?hl=vi&project=ci-cd-jenkins-terraform) on GCP 
- Click on `Create service account` with name `jenkin-tf` and assign a role `Storage Admin` and click `Done`

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/7174b28a-a012-49f0-b06e-6c1d9198b28d)

- Click on this service account that created and switch `KEYS` tab and download `JSON` key

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/d8d8a0c3-78e6-459f-9c65-95c54b545bba)

- Go back to Jenkin and add credentials (Manage Jenkins -> Credentials -> System -> Global credentials (unrestricted) -> Add Credentials)

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/8772605e-4090-45ed-8926-3d85889521c4)

- Choose type kind `Secret file` and upload the Key JSON file and give a name `gcp-key` that the same name in Jenkins config file

- Next, go back to github, and go to `Settings` -> `Developer Settings` -> Tokens

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/98f13b8c-ba46-477f-a098-ecffe07fd7b6)

- Generate new token (Classic)

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/42262698-a501-40ad-986f-baa570275a49)

- Give a note name `jenkin-demo` and check only `repo` and click generate

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/338c0024-e753-42bd-afd9-7cabcef0f1d6)

- Copy this token for this case like this `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`

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/d32d27f1-bb97-431f-ae0a-4869f1a2ea75)

- Go back to jenkins again and add credentials for that token and choose the type `Secret text` and give a name `git-token`

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/5b7fab75-b22b-4a06-8126-9782c665119b)

### Create new pipeline
- Go to `Add item` -> Enter name `gcp-tf-demo` and choose pipeline

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/a93b2002-aed7-4354-9ffd-fd7ccf77f96a)

- Fill some infomation. Remember to add token credentials on this URL github repository

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/4c9afcd0-0edb-464d-9851-81305dd09cc6)

- Make sure, you should use `master` branch instead of using `main` branch

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/18eb6985-f455-4bdb-a048-6c173b9362dc)

- Go back to jenkinsfile to check everything that match with configuration in Jenkins
- Click on `Build now` to see the result of pipeline

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/8a761308-7160-44ac-93e0-f46cc3b25b1c)

### Setup webhook for automatically trigger pipeline whenever someone commit to github
- Go to `configure` -> Check option `GitHub hook trigger for GITScm polling` -> Click Save
- Go back to github repo -> Click on `Settings` -> Click on `Webhooks` -> Add webhook and fill some information like this

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/a73cb486-cbc2-4712-8a13-a200c6121906)

### Test
- Go to the github and modify the `main.tf` file like this

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/df633729-3c3f-46b5-a23a-d0b5944bfe2b)

- And check the result of pipeline on Jenkins

  ![image](https://github.com/hieunguyen0202/CI-CD-Pipeline-using-Jenkins-and-Terraform/assets/98166568/11722daf-33ac-4d39-8405-1aa679a7425a)




  

  

  




  

  

  

  

  


  
  
  




  

  

  

  

  
 
  


  
