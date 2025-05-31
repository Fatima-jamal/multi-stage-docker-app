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
