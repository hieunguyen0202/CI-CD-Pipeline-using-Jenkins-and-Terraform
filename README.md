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
  - Click on `Deploy`
 
  


  
