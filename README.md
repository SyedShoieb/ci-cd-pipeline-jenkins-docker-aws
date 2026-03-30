# 🚀 CI/CD Pipeline using Jenkins, Docker & AWS

---

## 📌 Project Overview

This project demonstrates a complete CI/CD pipeline where every code push automatically triggers build and deployment.

A Node.js application is containerized using Docker, deployed on AWS EC2, and automated using Jenkins.

---

## 🎯 Objectives

* Automate build and deployment process
* Learn Jenkins pipeline (CI/CD)
* Dockerize an application
* Deploy on AWS EC2
* Integrate GitHub Webhook for auto-trigger

---

## 🏗️ Tech Stack

* Jenkins (CI/CD)
* Docker (Containerization)
* AWS EC2 (Hosting)
* Node.js (Application)
* Git & GitHub (Version Control)

---

## ⚙️ Architecture Flow

GitHub → Jenkins → Docker → AWS EC2

1. Developer pushes code to GitHub
2. Webhook triggers Jenkins
3. Jenkins pulls latest code
4. Builds Docker image
5. Stops old container
6. Runs new container

---

## 🚀 Step-by-Step Implementation

---

### 1️⃣ Launch EC2 Instance

* Instance Type: t2.micro
* OS: Ubuntu
* Open Ports:

  * 22 (SSH)
  * 8080 (Jenkins)
  * 3000 (Application)

---

### 2️⃣ Install Docker

```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```

---

### 3️⃣ Run Jenkins in Docker

```bash
sudo docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --group-add $(getent group docker | cut -d: -f3) \
  --name jenkins \
  jenkins/jenkins:lts
```

---

### 4️⃣ Access Jenkins

Open in browser:

http://<EC2-IP>:8080

Get initial password:

```bash
sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

### 5️⃣ Install Required Plugins

* Git Plugin
* Pipeline Plugin
* GitHub Integration Plugin
* Docker Pipeline Plugin

---

### 6️⃣ Create Jenkins Pipeline Job

```groovy
pipeline {
    agent any

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/SyedShoieb/ci-cd-pipeline-jenkins-docker-aws.git'
            }
        }

        stage('Check Docker') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-app .'
            }
        }

        stage('Stop Old Container') {
            steps {
                sh 'docker stop devops-container || true'
                sh 'docker rm devops-container || true'
            }
        }

        stage('Run New Container') {
            steps {
                sh 'docker run -d -p 3000:3000 --name devops-container devops-app'
            }
        }
    }
}
```

---

### 7️⃣ Setup GitHub Webhook

* Payload URL:

```
http://<EC2-IP>:8080/github-webhook/
```

* Content Type: application/json
* Event: Just the push event
* SSL: Disable

---

### 8️⃣ Test Pipeline

```bash
git add .
git commit -m "test webhook"
git push origin main
```

Expected:
Jenkins auto triggers build

---

### 9️⃣ Access Application

```
http://<EC2-IP>:3000
```

---

## ⚠️ Issues Faced & Solutions

---

### ❌ Issue 1: sudo not found

Error:
sudo: not found

Cause:
Jenkins container does not have sudo

Solution:
Removed sudo from pipeline commands

---

### ❌ Issue 2: Docker permission denied

Error:
permission denied while connecting to docker daemon

Solution:

```bash
sudo chmod 666 /var/run/docker.sock
```

Also used:

```bash
--group-add docker
```

---

### ❌ Issue 3: docker command not found

Cause:
Docker CLI not installed inside container

Solution:

```bash
apt install docker.io -y
```

---

### ❌ Issue 4: docker ps not working

Error:
cannot connect to docker daemon

Cause:
Docker socket not mounted

Solution:

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

---

### ❌ Issue 5: npm install very slow

Cause:
Heavy dependency installation

Solution:

Dockerfile optimization:

```dockerfile
RUN npm install --no-audit --no-fund
```

Add .dockerignore:

```
node_modules
.git
npm-debug.log
```

---

### ❌ Issue 6: Jenkins build stuck

Cause:
Low EC2 performance

Solution:

* Wait patiently
* Do not stop build
* Clean Docker:

```bash
sudo docker system prune -a -f
```

## 📈 Future Improvements

* Add Nginx reverse proxy
* Add custom domain
* Enable HTTPS (SSL)
* Use Docker Compose
* Move to Kubernetes
* Add monitoring tools

---

## 👨‍💻 Author

Syed Shoieb

GitHub:
https://github.com/SyedShoieb
