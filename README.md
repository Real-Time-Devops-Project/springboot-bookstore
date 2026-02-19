# Spring Boot + MySQL example 
## Technologies used:
* Spring Boot 3.1.2
* MySQL 8
* Java 17
* Maven 3
* JUnit 5
* Docker

before preparing the jenkins file and pipeline, we have to collect details like credentials of database, which commands we have to run.

sudo apt update && sudo apt install -y ansible

git clone this repo  jenkins-slave-config-ansible-roles

 ansible-playbook buildsetup.yml to install docker

 docker info

docker run -d --name sonarqube -p 9000:9000 sonarqube

inbound rules
jemkins server port 8080
sonarqube server port 9000

generate sonarqube token to use in jenkins, go to myaccount, security, generate token, name demom goal access generate token, copy the token and use it in jenkins configuration for sonarqube server , in jenkins use this as a secret text and use the secret text in sonarqube server configuration in jenkins 
and also add the sonarqube url to jenkins as "mysonarqube" 
add a webhook in sonarqube server:
http:<jenkins-server-ip/url>:8080/sonarqube-webhook/  administration, configuration, webhooks, add webhook, name jenkins-webhook, url http://<jenkins-server-ip>:8080/sonarqube-webhook/ , save

 mange jenkins, system, SonarQube installations add sonarqube , server url http://<sonarqube-server-ip>:9000, credentials select the secret text which we created for sonarqube token, test connection should be successful

 Create "AWSCred" credentials in jenkins for aws cli to connect ecr,
 create new credentials for aws cli to connect ecr, mange jenkins, credentials, add credentials, select aws credentials, access key id and secret access key which has access to ecr, give it an id "AWSCred"

provide git hub credentials in jenkins to pull the code from gitlab, create new credentials, select username and password, give the username and password of gitlab account which has access to the repo, give it an id "GitlabCred"

pre requisites, jenkins servr with slave machine, sonarqube server with sonar-scanner, artifactory server aws ecr, kind cluster, aws cli configured with ecr access, kubectl cli configured with kind cluster context

jenkins plugins required for this project: git , parameterized trigger plugin, github/gitlab plugin, amazon ecr plugin, pipeline aws steps, docker pipeline, quality gates, prometheus metrics, sonarqube-scanner 

## How to run it
```
# Build Jar & Skip Unit Test why we don't have database currently installed so we are skipping unit test
$ mvn clean package -Dmaven.test.skip=true 

# Run MySQL backend container for testing
$ docker run --name mydb -p 3306:3306 -e MYSQL_USER=bookstore -e MYSQL_PASSWORD=password -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=bookstore -d mysql:8.1

# Check if mysql is working fine
$ docker exec -it mydb mysql -uroot -ppassword
  mysql> show databases;
  mysql> use bookstore;
  mysql> show tables;
  mysql> select * from books;

# Deploy the application
$ nohup java -jar target/springboot-mysql-9739110917.jar 2>&1 &

# Check if its up & running
$ curl -s http://localhost:8080/books

# Add a entry to test the application
$ curl -X POST -H "Content-Type: application/json" -d '{"title":"Book A", "price":49.99, "publishDate":"2024-04-12"}' "http://localhost:8080/books"

# Healcheck Probes
$ curl -s http://localhost:8080/actuator/health/liveness
$ curl -s http://localhost:8080/actuator/health/readiness

# dummy commit Apr/12
#test
```
📚 Spring Boot Bookstore — Production Ready Architecture

A complete Spring Boot + MySQL application with:

REST API

Dockerized setup

CI/CD with Jenkins

Code Quality with SonarQube

Image push to AWS ECR

Kubernetes Deployment (Kind)

Monitoring via Actuator & Prometheus

🛠 Technologies Used

Spring Boot 3.1.2

Java 17

MySQL 8

Maven 3

JUnit 5

Docker

Jenkins

SonarQube

AWS ECR

Kubernetes (Kind)

Prometheus + Actuator

🏗 System Architecture

flowchart LR
  Client -->|HTTP| BookController
  BookController --> BookService
  BookService --> BookRepository
  BookRepository --> MySQL
  BookController --> Actuator
  Actuator --> Prometheus
  Jenkins -->|Build & Test| Maven
  Maven --> Docker
  Docker --> AWS_ECR
  AWS_ECR --> Kubernetes
  Jenkins --> SonarQube

📂 Project Structure

src/
 ├── main/
 │   ├── java/com/mkyong/
 │   │   ├── StartApplication.java
 │   │   └── book/
 │   │       ├── Book.java
 │   │       ├── BookController.java
 │   │       ├── BookService.java
 │   │       └── BookRepository.java
 │   └── resources/
 │       └── application.properties
 └── test/
     └── BookControllerTest.java
Dockerfile
pom.xml
deployments/
README.md


🔎 API Endpoints

| Method | Endpoint                        | Description      |
| ------ | ------------------------------- | ---------------- |
| GET    | `/books`                        | List all books   |
| GET    | `/books/{id}`                   | Get book by ID   |
| POST   | `/books`                        | Create book      |
| PUT    | `/books`                        | Update book      |
| DELETE | `/books/{id}`                   | Delete book      |
| GET    | `/books/find/title/{title}`     | Find by title    |
| GET    | `/books/find/date-after/{date}` | Books after date |

🗄 Database Configuration

Configured in:src/main/resources/application.properties

Key Properties:

spring.datasource.url=jdbc:mysql://localhost:3306/bookstore
spring.datasource.username=bookstore
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=create-drop

🚀 Local Setup (Manual Mode)

1️⃣ Build the Application

We skip tests initially because MySQL is not yet running.

mvn clean package -Dmaven.test.skip=true

2️⃣ Run MySQL Container

docker run -d \
--name mydb \
-p 3306:3306 \
-e MYSQL_USER=bookstore \
-e MYSQL_PASSWORD=password \
-e MYSQL_ROOT_PASSWORD=password \
-e MYSQL_DATABASE=bookstore \
mysql:8

Verify:

docker exec -it mydb mysql -uroot -ppassword
show databases;
use bookstore;
show tables;

3️⃣ Run Application

nohup java -jar target/springboot-mysql-*.jar &

Test:

curl http://localhost:8080/books

Create Book:

curl -X POST \
-H "Content-Type: application/json" \
-d '{"title":"Book A","price":49.99,"publishDate":"2024-04-12"}' \
http://localhost:8080/books

4️⃣ Health Checks

curl http://localhost:8080/actuator/health/liveness
curl http://localhost:8080/actuator/health/readiness


🔐 CI/CD Setup — Complete Guide

Before creating Jenkins pipeline, collect:

Database credentials

SonarQube token

AWS Access Key & Secret

Git credentials

ECR repository name

Kubernetes cluster access

🖥 Jenkins Server Setup
Install Required Packages

sudo apt update
sudo apt install -y ansible

Clone Ansible repo:

git clone jenkins-slave-config-ansible-roles
ansible-playbook buildsetup.yml

Verify Docker:

docker info

🔍 SonarQube Setup

Run container:

docker run -d --name sonarqube -p 9000:9000 sonarqube

http://<server-ip>:9000

🔑 Generate Sonar Token

Login to SonarQube

My Account → Security

Generate Token

Name: demom-goal-access

Copy Token

🔗 Add SonarQube to Jenkins

Manage Jenkins → System → SonarQube Installations:

Name: mysonarqube

URL: http://<sonarqube-server-ip>:9000

Credentials: Secret Text (paste token)

Test Connection → Must be successful

🔔 Configure Webhook

SonarQube → Administration → Webhooks

Add:
Name: jenkins-webhook
URL: http://<jenkins-ip>:8080/sonarqube-webhook/

☁ AWS ECR Integration
Create AWS Credentials in Jenkins

Manage Jenkins → Credentials → Add

Kind: AWS Credentials

ID: AWSCred

Access Key & Secret Key (ECR access)

🧾 Git Credentials

Add GitLab/GitHub credentials:

Type: Username & Password

ID: GitlabCred

Used to pull source code.

📦 Required Jenkins Plugins

Install:

Git Plugin

GitHub / GitLab Plugin

Pipeline

Docker Pipeline

SonarQube Scanner

Quality Gates

Amazon ECR Plugin

Pipeline AWS Steps

Prometheus Metrics

Parameterized Trigger Plugin

🐳 Docker Build Strategy

Dockerfile builds the jar and exposes port 8080.

Pipeline Steps:

Checkout Code

Maven Build

Sonar Scan

Quality Gate Wait

Build Docker Image

Push to AWS ECR

Deploy to Kubernetes

☸ Kubernetes Deployment (Kind)

Prerequisites:

AWS CLI configured

kubectl configured

Kind cluster running

Deploy:

kubectl apply -f deployments/

Verify:

kubectl get pods
kubectl get svc

📊 Observability

Actuator endpoints enabled:

/actuator/health

/actuator/prometheus

Prometheus scrapes metrics from application.

🔄 CI/CD Flow Summary

sequenceDiagram
  participant Dev
  participant Git
  participant Jenkins
  participant Sonar
  participant Docker
  participant ECR
  participant K8s

  Dev->>Git: Push Code
  Git->>Jenkins: Trigger Build
  Jenkins->>Sonar: Code Scan
  Sonar-->>Jenkins: Quality Gate
  Jenkins->>Docker: Build Image
  Docker->>ECR: Push Image
  Jenkins->>K8s: Deploy

📌 Security Considerations

Store tokens in Jenkins Credentials

Never hardcode AWS keys

Restrict inbound rules:

| Service   | Port |
| --------- | ---- |
| Jenkins   | 8080 |
| SonarQube | 9000 |
| MySQL     | 3306 |

🧪 Testing Strategy

Unit Tests — JUnit 5

Integration Tests — TestContainers

Sonar Coverage — JaCoCo

📈 Production Best Practices

Use RDS instead of container MySQL

Use separate namespaces in Kubernetes

Enable TLS

Enable ECR image scanning

Enable RBAC in Kubernetes

