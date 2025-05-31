# README.md

## Digital Payment Portal - DevOps Final Year Project

This project is a secure, scalable, and containerized deployment of a Java-based digital payment login portal. It uses Terraform for Infrastructure as Code (IaC), Docker for containerization, GitHub Actions for CI/CD, and AWS cloud services for hosting.

---

## Features

* Java Spring Boot backend with JSP UI
* PostgreSQL database hosted on AWS RDS (private subnet)
* Dockerized deployment using multi-stage builds
* GitHub Actions for automated Maven + Docker builds
* Modular Terraform infrastructure on AWS:

  * VPC, Subnets, Route Tables
  * EC2 for App
  * Application Load Balancer with Health Checks
  * Route 53 custom domain
  * Metabase BI tool on separate EC2
  * SSH Tunneling for secure DB access
* Domain: `http://fatimajamal.devopsagent.online`
* Metabase: `http://54.183.13.31:3000`

---

## Architecture Overview

```
Client
   |
Route 53 (DNS)
   |
Application Load Balancer (HTTP:80)
   |
Target Group (port 8081)
   |
EC2 (Dockerized Java Spring Boot App)
   |
Private PostgreSQL RDS
   |
EC2 (Dockerized Metabase Dashboard)
```

---

## Repository Structure

```
├── Dockerfile
├── pom.xml
├── .github/workflows/
│   ├── maven.yml
│   └── docker-build.yml
├── terraform/
│   ├── main.tf
│   ├── modules/
│   │   ├── vpc/
│   │   ├── ec2/
│   │   ├── rds/
│   │   ├── alb/
│   │   ├── asg/
│   │   ├── bi_ec2/
│   │   └── security_groups/
├── src/ (Java Spring Boot App)
└── application.properties
```

---

## Getting Started

### Prerequisites

* AWS CLI
* Terraform CLI
* Docker
* Maven
* AWS Account with IAM permissions

### Terraform Setup

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Docker Workflow

```bash
mvn clean install -DskipTests
docker build -t fatimajamal779/java-login-app:latest .
docker push fatimajamal779/java-login-app:latest
```

### GitHub Actions

* Any push to `main` triggers Maven build + Docker build/push via GitHub Actions.

### SSH Tunneling for RDS Access

```bash
ssh -i FJMS.pem -L 5432:<rds-endpoint>:5432 ec2-user@<ec2-public-ip>
```

Use `localhost:5432` for DBeaver or Spring Boot JDBC URL.

---

## Demo

* Login/Register: `http://fatimajamal.devopsagent.online`
* Metabase Dashboard: `http://54.183.13.31:3000`
* Loom Video Demo: [https://www.loom.com/share/c79e224c5f8e46dcba91171554cd853e](https://www.loom.com/share/c79e224c5f8e46dcba91171554cd853e)

---

## Author

**Fatima Jamal**
Final Year DevOps Project | IBA

# DEPLOYMENT\_GUIDE.md

## Deployment Guide - Digital Payment Portal

This guide explains how to deploy the entire stack from source using Terraform, Docker, and manual SSH-based container setup.

---

### Step 1: Clone Repository

```bash
git clone https://github.com/Fatima-jamal/multi-stage-docker-app.git
cd multi-stage-docker-app
```

---

### Step 2: Configure AWS Credentials

Ensure your AWS credentials are configured:

```bash
aws configure
```

---

### Step 3: Terraform Deployment

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

> Do not run apply again if infrastructure is already stable.

Modules provision:

* VPC, public/private subnets
* Security groups for EC2, ALB, RDS
* EC2 instance for app + Metabase
* PostgreSQL RDS
* ALB with HTTP listener
* Route 53 domain

---

### Step 4: Build and Push Docker Image

```bash
mvn clean install -DskipTests
docker build -t fatimajamal779/java-login-app:latest .
docker push fatimajamal779/java-login-app:latest
```

---

### Step 5: SSH into EC2 & Run Container

```bash
ssh -i FJMS.pem ec2-user@<ec2-public-ip>

# On EC2:
docker pull fatimajamal779/java-login-app:latest
docker run -d -p 8081:8081 fatimajamal779/java-login-app:latest
```

---

### Step 6: Validate Application

* Open ALB DNS or domain: `http://fatimajamal.devopsagent.online/login`
* Health checks should pass

---

### Step 7: Deploy Metabase

SSH into the BI EC2 instance:

```bash
sudo docker run -d -p 3000:3000 metabase/metabase
```

Connect to RDS during setup.

---

### Step 8: Connect to PostgreSQL via SSH Tunnel

```bash
ssh -i FJMS.pem -L 5432:<rds-endpoint>:5432 ec2-user@<ec2-public-ip>
```

Use DBeaver or Spring Boot JDBC with:

```
jdbc:postgresql://localhost:5432/postgres
```

---

### Step 9: CI/CD

GitHub Actions automate Maven and Docker workflows. See `.github/workflows/` directory.

---

### Step 10: Monitor & Clean Up

Use AWS Console to:

* Verify ALB target health
* View RDS metrics
* Stop EC2s after demo

To destroy infrastructure:

```bash
cd terraform
terraform destroy
```

---

End of Deployment Guide.
