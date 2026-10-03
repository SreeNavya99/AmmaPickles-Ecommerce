Amma Pickles — AWS DevOps Project

Project Overview

Amma Pickles is an e-commerce microservices application being used as a practical AWS DevOps / CI-CD project.

The project focuses on building a production-style AWS infrastructure and CI pipeline using Terraform, Jenkins, Nexus, Docker, Amazon ECR, and later Amazon EKS.

Application Services

auth-service

user-service

address-service

category-service

product-service

cart-service

order-service

notification-service

Technology Stack

Application

Java 17

Spring Boot

Maven

REST APIs

DevOps / CI

GitHub

Jenkins

Maven

Nexus Repository

Docker

Amazon ECR

AWS

VPC

Public and private subnets

Internet Gateway

NAT Gateway

Bastion host

EC2

RDS MySQL

Application Load Balancer

IAM

Amazon ECR

AWS Secrets Manager

AWS Systems Manager

Infrastructure as Code

Terraform

S3 remote Terraform state

S3 state locking with lockfile

Future Deployment

Amazon EKS

Kubernetes

AWS Architecture

Current high-level architecture:

                         Internet
                            |
                            v
                         ALB
                            |
                    Private App Subnet
                            |
              +-------------+-------------+
              |                           |
              v                           v
        Application / CI EC2            RDS
              |
       +------+----------------+
       |                       |
       v                       v
    Jenkins                  Nexus
     :8082                    :8081
       |
       +------------------+
       |                  |
       v                  v
   Docker Engine         ECR
                           |
                +----------+----------+
                |          |          |
             Services   Services   Services

Jenkins and Nexus currently run on the same existing private App/CI EC2 instance.

AWS Region

Region: ap-northeast-1
Account: configured through AWS/Terraform

The repository should not require AWS access keys to be committed into source control.

Terraform

Terraform manages the AWS infrastructure.

Terraform Structure

terraform/
├── backend.tf
├── ec2.tf
├── ecr.tf
├── iam.tf
├── locals.tf
├── network.tf
├── outputs.tf
├── provider.tf
├── rds.tf
├── security_groups.tf
├── terraform.tfvars
├── variables.tf
├── versions.tf
└── modules/
    ├── addons/
    ├── compute/
    ├── database/
    ├── eks/
    ├── iam/
    ├── network/
    ├── security/
    └── storage/

Terraform Backend

Terraform state is stored remotely in S3.

S3 bucket:
amma-pickles-terraform-state-206632868064

State key:
amma-pickles/terraform.tfstate

Region:
ap-northeast-1

The backend uses S3 encryption and the Terraform S3 lockfile mechanism.

Terraform Workflow

Feature Branch
      |
      v
Pull Request
      |
      v
Terraform Plan
      |
      v
Review
      |
      v
Merge to main
      |
      v
GitHub Actions
      |
      v
Terraform Apply
      |
      v
Production Environment Approval

GitHub Actions authenticates to AWS using GitHub OIDC.

ECR

Amazon ECR repositories are managed through Terraform.

Repositories:

amma-pickles/auth-service
amma-pickles/user-service
amma-pickles/address-service
amma-pickles/category-service
amma-pickles/product-service
amma-pickles/cart-service
amma-pickles/order-service
amma-pickles/notification-service

ECR configuration uses image immutability and scan-on-push.

Image Tagging

Jenkins creates traceable image tags using:

BUILD_NUMBER-GIT_COMMIT

Example:

23-a81f4c2

Images are pushed as:

<account>.dkr.ecr.<region>.amazonaws.com/amma-pickles/<service>:<tag>

Jenkins

Jenkins is the CI engine.

Jenkins runs in Docker on the existing App/CI EC2.

Jenkins Container

Container: jenkins
Image: jenkins/jenkins:lts-jdk17

Host Port: 8082
Container Port: 8080

Persistent Data:
 /data/jenkins

Jenkins uses Java 17.

The Jenkins container Java home is:

/opt/java/openjdk

Maven is configured as a Jenkins-managed tool.

Jenkins Tools

JDK:
java17

Maven:
maven3

Jenkins Credentials

GitHub authentication uses an SSH credential.

Nexus authentication uses a Jenkins username/password credential.

The Nexus credential ID used by the Jenkinsfile is:

Jenkins-nexus

Do not put Nexus passwords, GitHub private keys, or AWS access keys into the Jenkinsfile.

Nexus Repository

Nexus runs on the same EC2 instance as Jenkins.

Container: nexus
Image: sonatype/nexus3:latest

Host Port: 8081
Container Port: 8081

Persistent Data:
 /data/nexus

Both Jenkins and Nexus use the Docker network:

amma-pickles-ci

Maven Repositories

Hosted repositories:

amma-pickles-maven-releases
amma-pickles-maven-snapshots

Group repository:

amma-pickles-maven-group

The group repository includes the hosted repositories and Maven Central for dependency consumption.

Maven artifacts are published to the appropriate hosted release/snapshot repository.

Jenkins CI Pipeline

The current CI pipeline is:

GitHub
   |
   v
Jenkins
   |
   +--> Checkout
   |
   +--> Build & Test
   |
   +--> Publish Maven Artifacts
   |        |
   |        v
   |      Nexus
   |
   +--> Build Docker Images
   |
   +--> Login to Amazon ECR
   |
   +--> Push Images to ECR

Pipeline Stages

1. Checkout

Jenkins checks out the Git repository using the configured GitHub SSH credential.

2. Build & Test

Each microservice is built independently using the repository Maven Wrapper:

../mvnw clean verify

The pipeline processes:

auth-service
user-service
address-service
category-service
product-service
cart-service
order-service
notification-service

3. Publish Maven Artifacts

Each service publishes its Maven artifact to Nexus:

../mvnw deploy

Jenkins injects Nexus credentials at runtime.

The Maven settings file is managed by Jenkins.

Managed Maven settings ID:

amma-pickles-maven-settings

4. Build Docker Images

Each service has its own Dockerfile.

The Docker images use Java 17 runtime images.

Example runtime base image:

eclipse-temurin:17-jre

The Dockerfile copies the generated Maven JAR:

target/*.jar

into the container.

5. Login to ECR

Jenkins uses the AWS CLI and the EC2 instance IAM role:

aws ecr get-login-password

No static AWS access keys are required for Jenkins.

6. Push Images to ECR

Images are tagged with a traceable build/revision tag and pushed to the corresponding ECR repository.

Jenkinsfile

The current CI Jenkinsfile contains these stages:

Checkout
Build & Test
Publish Maven Artifacts to Nexus
Build Docker Images
Login to Amazon ECR
Push Images to ECR

EKS/Kubernetes deployment is not part of the current CI pipeline.

EKS deployment can be added later as a separate CD/deployment phase.

IAM

The Jenkins/App EC2 uses the IAM role:

amma-pickles-devops-role

The role is attached through an EC2 instance profile.

The role currently includes the permissions required for the existing project environment.

The Jenkins CI pipeline specifically requires ECR authentication and image-push permissions.

The long-term goal is to manage IAM completely through Terraform and reduce broad permissions to least privilege.

Persistent Storage

The Jenkins/Nexus EC2 has a dedicated EBS volume.

Volume type: gp3
Size: 20 GB
Mount point: /data

Storage layout:

/data/
├── jenkins/
└── nexus/

The volume is mounted persistently through /etc/fstab.

Terraform manages the EBS volume configuration.

Database

RDS MySQL is deployed in private DB subnets.

Identifier:
amma-pickles-db

Engine:
MySQL 8.4.11

Instance class:
db.t4g.micro

Database:
amma_pickles

Database credentials are managed through AWS Secrets Manager.

RDS uses a dedicated security group and accepts MySQL traffic from the application security group.

RDS has Terraform deletion protection using:

lifecycle {
  prevent_destroy = true
}

Do not casually destroy or recreate the database.

Security Groups

The major traffic paths are:

Internet
   |
   v
ALB
   |
   v
Application
   |
   v
RDS

Administrative access:

Administrator
   |
   v
Bastion
   |
   v
Private App/CI EC2

Jenkins and Nexus are not directly exposed to the public internet.

Local access can be provided through an SSH tunnel through the bastion.

Example:

ssh -i "keypair.pem" -N \
  -L 8081:10.0.11.63:8081 \
  -L 8082:10.0.11.63:8082 \
  ec2-user@<BASTION_PUBLIC_IP>

Then:

http://localhost:8081  -> Nexus
http://localhost:8082  -> Jenkins

Docker

Docker is installed at the EC2 host level.

Jenkins uses the host Docker daemon through:

/var/run/docker.sock

Jenkins and Nexus are connected to:

amma-pickles-ci

Docker image builds are performed by Jenkins during the CI pipeline.

Development / CI Validation

Before considering the CI pipeline successful, verify:

[ ] GitHub checkout works
[ ] Java 17 is available to Jenkins
[ ] Maven builds all services
[ ] Tests/verification complete successfully
[ ] Maven artifacts publish to Nexus
[ ] Docker images build successfully
[ ] Jenkins can authenticate to ECR
[ ] All service images push successfully to ECR
[ ] Image tags are traceable to the Jenkins build and Git commit

Future CD / Kubernetes

Amazon EKS is planned for the deployment phase.

The intended future flow is:

GitHub
   |
   v
Jenkins CI
   |
   +--> Maven
   |
   +--> Nexus
   |
   +--> Docker
   |
   +--> ECR
   |
   v
Amazon EKS
   |
   v
Kubernetes
   |
   v
Amma Pickles Microservices

EKS/Kubernetes deployment should be added only after the CI pipeline is stable.

Project Principles

Infrastructure should be reproducible through Terraform.

AWS credentials should not be hardcoded in source code.

Jenkins credentials should be stored in Jenkins Credentials.

Secrets should be stored in appropriate secret-management systems.

Docker images should use traceable tags instead of relying only on latest.

Production infrastructure should not be destroyed casually.

IAM permissions should move toward least privilege.

CI and CD responsibilities should remain clearly separated.

Application builds should fail the pipeline when compilation, verification, artifact publishing, image building, or image pushing fails.

Current CI Goal

The immediate goal is to achieve a completely successful Jenkins pipeline:

GitHub
  ↓
Checkout
  ↓
Build & Test
  ↓
Nexus
  ↓
Docker Build
  ↓
ECR Login
  ↓
ECR Push
  ↓
SUCCESS

Once this is stable, the project can move to the CD/EKS deployment phase.

