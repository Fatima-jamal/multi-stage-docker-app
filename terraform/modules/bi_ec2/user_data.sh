#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker

# Run Metabase
docker run -d -p 3000:3000 --name metabase metabase/metabase

# Run SonarQube
docker run -d -p 9000:9000 --name sonarqube sonarqube

# Run Grafana
docker run -d -p 3001:3000 --name grafana grafana/grafana
