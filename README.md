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


