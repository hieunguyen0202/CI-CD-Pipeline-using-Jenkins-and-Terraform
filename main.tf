resource "google_storage_bucket" "my-bucket" {
  name                     = "githubdemo-bucket-0011"
  project                  = "ci-cd-jenkins-terraform"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}
#
#
resource "google_storage_bucket" "my-bucket-2" {
  name                     = "githubdemo-bucket-0012"
  project                  = "ci-cd-jenkins-terraform"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}

#
