# CICD-series: Day 1 - Terraform + Jenkins

Creates a small EC2 web server (Amazon Linux 2023 + Apache) in the default VPC,
deployed by a Jenkins pipeline.

## Layout
```
Jenkinsfile                          # pipeline (init, validate, plan, apply/destroy)
Day-1-terraform-cicd-jenkins/
  provider.tf  variables.tf  main.tf  outputs.tf
```

## Jenkins server requirements
- Terraform installed for the `jenkins` user
- EC2 IAM role attached (e.g. AmazonEC2FullAccess) - no access keys needed

## Run
Jenkins -> job -> **Build with Parameters** -> `ACTION = apply` (create) or `destroy` (delete).
After apply, open `http://<public_ip>` (shown in the build log).
