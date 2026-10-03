Amma Pickles — AWS DevOps Project

A production-style AWS DevOps implementation for the Amma Pickles Ecommerce microservices application.

The project focuses on building a reproducible cloud infrastructure and CI pipeline using Terraform, AWS, GitHub, Jenkins, Nexus, Docker, and Amazon ECR, with Amazon EKS planned for the deployment stage.

1. Project Overview

Application: Amma Pickles Ecommerce

Architecture: Microservices

Application Services

auth-service

user-service

address-service

category-service

product-service

cart-service

order-service

notification-service

The DevOps implementation is designed around the following flow:

Developer
   |
   v
GitHub
   |
   v
Jenkins
   |
   +--------------------+
   |                    |
   v                    v
Build & Test        Maven Deploy
   |                    |
   |                    v
   |                  Nexus
   |                    |
   +---------+----------+
             |
             v
       Docker Build
             |
             v
          Amazon ECR
             |
             v
        Amazon EKS
        (deployment)

2. Technology Stack

Application / Build

Java

Spring Boot

Maven

Maven Wrapper

Source Control

Git

GitHub

CI/CD

Jenkins

GitHub

Jenkins Pipeline

Artifact Management

Sonatype Nexus Repository

Containers

Docker

Amazon ECR

Infrastructure as Code

Terraform

AWS Services

VPC

EC2

EBS

RDS

ALB

IAM

ECR

EKS

S3

Secrets Manager

CloudWatch

Systems Manager

3. AWS Environment

AWS Account: 206632868064

AWS Region: ap-northeast-1

The project uses Terraform to manage the AWS infrastructure.

Main Infrastructure

AWS
|
+-- VPC
|   |
|   +-- Public Subnets
|   |     +-- Bastion
|   |
|   +-- Private App Subnets
|   |     +-- Jenkins
|   |     +-- Nexus
|   |
|   +-- Private DB Subnets
|         +-- RDS MySQL
|
+-- Application Load Balancer
|
+-- Amazon ECR
|
+-- Amazon EKS
|
+-- S3
|     +-- Terraform Remote State
|
+-- Secrets Manager
|     +-- RDS credentials
|
+-- IAM

4. Terraform

Terraform is used as the primary Infrastructure as Code tool.

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
│
└── modules/
    ├── addons/
    ├── compute/
    ├── database/
    ├── eks/
    ├── iam/
    ├── network/
    ├── security/
    └── storage/

Terraform State

Terraform state is stored remotely in Amazon S3.

Bucket:
amma-pickles-terraform-state-206632868064

Key:
amma-pickles/terraform.tfstate

Region:
ap-northeast-1

The S3 backend uses a lock file to protect concurrent Terraform operations.

5. Terraform CI Workflow

Terraform changes are validated through GitHub Actions.

Pull Request
     |
     v
Terraform Init
     |
     v
Terraform Format Check
     |
     v
Terraform Validate
     |
     v
Terraform Plan

Changes merged/pushed to main continue through the apply stage.

main
 |
 v
Terraform Plan
 |
 v
Production Environment Approval
 |
 v
Terraform Apply

AWS authentication from GitHub Actions uses OIDC rather than storing long-lived AWS access keys.

6. EC2 CI Server

The project uses an existing private-subnet EC2 instance as the CI server.

The same EC2 host runs:

EC2
|
+-- Jenkins Container
|
+-- Nexus Container
|
+-- Docker Engine
|
+-- Java
|
+-- Git
|
+-- AWS CLI
|
+-- EBS Storage

The CI server is not directly exposed to the public internet.

Access is performed through the Bastion host using SSH tunneling.

7. Persistent CI Storage

A dedicated 20 GB gp3 EBS volume is used for Jenkins and Nexus data.

/data/
├── jenkins/
└── nexus/

The volume is mounted on the CI EC2 instance as:

/data

The mount is persisted using /etc/fstab.

Storage Design

EBS
 |
 v
/data
 |
 +-- jenkins
 |
 +-- nexus

This keeps CI application data separate from the EC2 root filesystem.

8. Jenkins

Jenkins runs as a Docker container.

Jenkins
Image:
jenkins/jenkins:lts-jdk17

Host Port:
8082

Container Port:
8080

Persistent Data:
/data/jenkins:/var/jenkins_home

Jenkins is connected to the CI Docker network:

amma-pickles-ci

Docker socket access is provided so Jenkins can build Docker images.

/var/run/docker.sock

9. Nexus Repository

Nexus runs as a Docker container on the same EC2 host.

Nexus
Image:
sonatype/nexus3:latest

Host Port:
8081

Container Port:
8081

Persistent Data:
/data/nexus:/nexus-data

Jenkins and Nexus communicate through the Docker network:

amma-pickles-ci

The Nexus repository structure is:

Hosted:
- amma-pickles-maven-releases
- amma-pickles-maven-snapshots

Group:
- amma-pickles-maven-group

The group repository is used for dependency resolution.

Hosted repositories are used for publishing application artifacts.

10. Maven Artifact Flow

Each microservice contains a Maven pom.xml.

The project uses:

Group ID:
com.ammapickles

Services use their service name as the artifact ID.

Snapshot artifacts are published to:

amma-pickles-maven-snapshots

Release artifacts are published to:

amma-pickles-maven-releases

Jenkins uses a managed Maven settings.xml configuration.

Credentials are stored in Jenkins Credentials rather than hardcoded in the repository.

11. Jenkins CI Pipeline

The Jenkins pipeline is designed around the following stages:

1. Checkout
      |
2. Build & Test
      |
3. Publish Maven Artifacts to Nexus
      |
4. Build Docker Images
      |
5. Login to Amazon ECR
      |
6. Push Images to ECR

Checkout

Jenkins checks out the source code from GitHub.

Build & Test

Each service is built using the Maven Wrapper.

mvnw clean verify

All eight services are processed by the pipeline.

Nexus

Successful Maven builds are deployed to Nexus.

Docker

A Docker image is created for every service.

ECR

Images are tagged and pushed to Amazon ECR.

12. Docker Image Tagging

Docker images are tagged using the Jenkins build number and Git commit.

Format:

BUILD_NUMBER-SHORT_GIT_COMMIT

Example:

25-8b1137f

This makes the image traceable to a specific CI build and source revision.

Example:

auth-service:25-8b1137f

The image is then pushed to:

206632868064.dkr.ecr.ap-northeast-1.amazonaws.com/amma-pickles/auth-service:25-8b1137f

13. Amazon ECR

The project contains one ECR repository for each microservice.

amma-pickles/auth-service
amma-pickles/user-service
amma-pickles/address-service
amma-pickles/category-service
amma-pickles/product-service
amma-pickles/cart-service
amma-pickles/order-service
amma-pickles/notification-service

ECR repositories use immutable image tags and scan-on-push configuration.

14. IAM

The CI EC2 instance uses an IAM role:

amma-pickles-devops-role

The role allows the EC2 environment to interact with AWS services required by the project.

The project currently uses a broad development/lab policy covering services such as:

ECR

EKS

IAM

RDS

EC2

CloudFormation

CloudWatch

CloudWatch Logs

Secrets Manager

Systems Manager

S3 Terraform state

STS

The policy is managed through Terraform.

For a production deployment, the permissions should be reduced according to the exact CI/CD responsibilities.

15. RDS Database

The application database is Amazon RDS for MySQL.

Identifier:
amma-pickles-db

Engine:
MySQL 8.4.11

Instance:
db.t4g.micro

Database:
amma_pickles

The database is located in private database subnets.

Database credentials are managed using AWS Secrets Manager.

The RDS resource has Terraform lifecycle protection against accidental destruction.

prevent_destroy = true

16. Network Security

The infrastructure separates workloads using security groups and private/public subnet boundaries.

High-level traffic flow:

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
Private EC2

CI access:

Bastion
   |
   +--> Jenkins : 8082
   |
   +--> Nexus   : 8081

Jenkins and Nexus are not intended to be directly exposed to the internet.

17. GitHub → Jenkins Integration

GitHub is the source repository:

https://github.com/SreeNavya99/AmmaPickles-Ecommerce.git

Jenkins uses an SSH credential for repository access.

The Jenkins-specific SSH key is stored inside Jenkins credentials.

GitHub contains the public key as a repository deploy key.

This avoids using a personal GitHub password/token directly inside Jenkins.

18. Jenkins Credentials

Sensitive values are stored using Jenkins Credentials.

Examples include:

GitHub SSH credential
Nexus username/password
AWS authentication

Credentials should not be committed to:

Jenkinsfile
pom.xml
settings.xml
Git repository
Dockerfile

The pipeline injects credentials only when required.

19. Current CI/CD Architecture

                    GitHub
                       |
                       v
                  Jenkins CI
                       |
          +------------+------------+
          |                         |
          v                         v
     Build & Test              Maven Deploy
          |                         |
          |                       Nexus
          |                         |
          +------------+------------+
                       |
                       v
                  Docker Build
                       |
                       v
                     ECR
                       |
                       v
                     EKS
                (deployment stage)

20. EKS Deployment

Amazon EKS is part of the planned deployment architecture.

The current project focuses first on completing the CI pipeline:

GitHub
   ↓
Jenkins
   ↓
Build & Test
   ↓
Nexus
   ↓
Docker
   ↓
ECR

The next deployment layer will connect ECR images to Kubernetes/EKS.

Expected future flow:

ECR
 |
 v
Amazon EKS
 |
 +-- auth-service
 +-- user-service
 +-- address-service
 +-- category-service
 +-- product-service
 +-- cart-service
 +-- order-service
 +-- notification-service

21. Project Principles

This project follows these DevOps principles:

Infrastructure as Code

AWS infrastructure is managed using Terraform.

Immutable Artifacts

Docker images are pushed to ECR using traceable image tags.

Centralized Artifact Management

Maven artifacts are stored in Nexus.

Secret Management

Credentials are stored in Jenkins Credentials or AWS Secrets Manager rather than source code.

Persistent CI Data

Jenkins and Nexus use dedicated EBS storage.

Private Infrastructure

CI and database resources are placed in private networking where appropriate.

Reproducibility

Infrastructure configuration and CI pipeline definitions are stored in Git.

Traceability

Every Docker image can be associated with:

Jenkins Build
      +
Git Commit

22. Repository Structure

AmmaPickles-Ecommerce/
│
├── auth-service/
├── user-service/
├── address-service/
├── category-service/
├── product-service/
├── cart-service/
├── order-service/
├── notification-service/
│
├── terraform/
│   ├── modules/
│   ├── backend.tf
│   ├── ec2.tf
│   ├── ecr.tf
│   ├── iam.tf
│   ├── network.tf
│   ├── rds.tf
│   ├── security_groups.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── versions.tf
│
├── .github/
│   └── workflows/
│       └── terraform.yaml
│
├── Jenkinsfile
├── mvnw
├── pom.xml
└── README.md

23. Development Workflow

The expected developer workflow is:

1. Developer changes code
        |
2. Commit changes
        |
3. Push to GitHub
        |
4. Jenkins detects/builds the change
        |
5. Maven build & tests
        |
6. Publish artifact to Nexus
        |
7. Build Docker image
        |
8. Push image to ECR
        |
9. Deploy to EKS

Terraform infrastructure changes follow the GitHub Actions workflow separately.

24. Current Project Status

Completed

AWS VPC infrastructure

Public/private subnet architecture

Bastion

Private CI EC2

RDS MySQL

ALB infrastructure

IAM infrastructure

ECR repositories

Terraform remote state

GitHub Actions Terraform workflow

Persistent EBS storage

Jenkins container

Nexus container

Jenkins/Nexus Docker network

GitHub → Jenkins connectivity

Maven configuration

Jenkins JDK/Maven configuration

Build & Test stage

Docker build preparation

ECR authentication/push validation

Current Focus

Complete and validate the full Jenkins CI pipeline:

Checkout
   ↓
Build & Test
   ↓
Nexus
   ↓
Docker Build
   ↓
ECR Push

Next Major Stage

ECR
 ↓
EKS
 ↓
Kubernetes Deployment

25. Useful CI Commands

Check running containers:

sudo docker ps

Check Jenkins logs:

sudo docker logs jenkins

Check Nexus logs:

sudo docker logs nexus

Check CI network:

sudo docker network inspect amma-pickles-ci

Check persistent storage:

df -h /data

Check Docker:

sudo systemctl status docker

26. Project Goal

The final goal is to demonstrate an end-to-end DevOps implementation for a real microservices application:

GitHub
   ↓
CI with Jenkins
   ↓
Maven Build & Test
   ↓
Nexus Artifact Repository
   ↓
Docker Images
   ↓
Amazon ECR
   ↓
Amazon EKS
   ↓
Running Microservices

Infrastructure is provisioned with Terraform and application delivery is automated through the CI/CD pipeline.

Project

Amma Pickles Ecommerce — AWS DevOps Project

Region: ap-northeast-1

Repository: SreeNavya99/AmmaPickles-Ecommerce

