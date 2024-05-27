# Hello World Web Application

This document outlines the setup, deployment, and functionality of a highly-available web application that when queried with a "GET" function via HTTP, message text is returned that reads 'hello world'.

## Project Requirements

- Google Cloud Platform Free Tier: <https://cloud.google.com/free/docs/gcp-free-tier>
- Deployed using Infrastructure-as-Code (IaC)
- Deploy a web application that results in posting “Hello World” through a web browser client device
- Select the hosting infrastructure service of your choice
- The displayed content should be the result of “Hello World” being stored within a database (hosted on a database or database service of your discretion)
- Any programming language can be used
- Assume that this web application is designed to be available to the general public, with large-scale growth anticipated
- Monitor the application
-- Use a monitoring solution of your choice
-- Reason as to why you chose to monitor the specific metrics that you did
- Other services
-- Any other services that you would like to implement that would be appropriate for the proposed applications’s scope
- Collect notes/compile documentation regarding your decisions made and experience in building your web application stack

### Application Requirements

- Terraform
- Python 3.x
- Flask
- Gunicorn
- Google Cloud SDK

## Application Overview

The application is built using Flask - a lightweight web application framework in Python, and served with Gunicorn - a Python WSGI HTTP Server for *NIX applications. This application is designed to connect to Google Firestore, a NoSQL document database built for automatic scaling, high performance, and ease of application development.

## Infrastructure as Code

For this project's requirements, terraform is my choice. Terraform is used to configure and deploy the required infrastructure to Google Cloud. In this case, a free-tier account was used to demonstrate a basic implementation to meet the requirements with very low initial cost.  

## Key Features of this Deployment

- Terraform
-- If you are familiar with terraform, you understand how straight-forward and quickly terraform can be used to "build" cloud-based virtual infrastructure.
-- This demonstration uses a sing "main.tf" file to implement the entire deployment
- **Flask Application**: Serves as the backend framework.
-- Flask is simple, yet powerful and robust web framework.
-- If you understand basic database operations and skills, you can leverage your DB-API skills to quickly create a backend service for specific queries.  
- **Gunicorn**: Enhances the serving capabilities of Flask
-- In the case of this application, flask would suffice for the purposes of demonstration. However flask is not considred to be a production-level service on its own and requirements call for a more robust front-end application to receive anonymous requests.  
-- Gunicorn is a perfect solution for the purposes of this project. Gunicorn is a robust front-end web service application with a specific purpose; buffering multiple client requests to ensure the core application (flask in this case) is protected and able to serve requests reliably.
- **Google Firestore**: A NoSQL database that stores and retrieves the message data.
-- For this project, serious thought was put into implementing a robust PostGreSQL database architecture using Patroni and pgbouncer, I decided for this excercise it makes sense to implement a NoSQL DB.
-- After settling on a KVP-style DB, my plan was to use somethong obvious, like redis or etcd, but then during my research I stumbled across "Firestore".
-- Firestore is serverless KVP database specific to GCP that is simple to implement using a python script coupled with a service definition in terraform.
-- Firestore data can be made available across multiple regions
- **GCP Monitoring**
-- Google has a good set of usefule metrics that come out of the box when implementing the Monitoring Google API using default settings
-- A dashboard is a good next setp and can added on to the terraform contained here that sets specific metrics you are interested in.

## Setup and Configuration

**NOTE:** This is an implementation run from a home machine outside of Google Cloud's infrastructure.

There is also a general assumption that you have establish an account in Google Cloud and have some knowledge of IAM.

If you need help on how to set up Google Cloud here is how to [Get Started](https://cloud.google.com/docs/get-started).

### Google SetUp

- Sign in to Google
- Create a Service Account in IAM with these roles:
-- Cloud Datastore Owner
-- Editor
-- Monitoring Admin
-- Viewer
- Download Service Account credentials to a local json file
- Create a new project in Google Cloud
- Ensure Google Cloud SDK installed
-- Example below for debian-based system

## Download The Google repo GPG Key

```bash
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
```

## Ensure key and Google repo is included in your apt repo lists

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

## Install Google Cloud SDK (required) and GKE Cloud Auth

```bash
sudo apt update && sudo apt -y install google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin
```

- Set project configuration

  ```bash
  gcloud config set project [project id]
  ```

- Ensure your service account can manage key services:

  `gcloud projects add-iam-policy-binding [project id] --member='serviceAccount:<your service acount>' --role='roles/monitoring.admin'`
  `gcloud projects add-iam-policy-binding [project id] --member='serviceAccount:<your service account>' --role='roles/datastore.owner'`

- Ensure Neccessary Google APIs are installed

  `gcloud services enable monitoring.googleapis.com firestore.googleapis.com container.googleapis.com`

### Installation Steps

1. **Clone the Repository**

  ```bash
  git clone https://github.com/bit-head/hello_gcp_terraform.git
  cd hello_gcp_terraform```

2. **Build the Container**

  ```bash
  docker build -t [container_registry_tag] .
  ```

  **NOTE:** See [Store Docker Images in Artifact Registry](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images)

3. **Set up a python virtual environment**

  ```bash
  mkdir venv
  python3 -m venv venv
  source venv/bin/activate
  ```

4. Install the modules in requirements.txt

  ```bash
  pip install -r requirements.txt
  ```

5. Ensure [Terraform](https://terraform.io) is installed and initialized
  
  ```bash
  terraform init
  ```

6. Run terraform plan with required values

  ```bash
  terraform plan -var "google_creds=[your google creds]" -var "container=[registry_tag]" -out plan
  ```

7. Run terraform with your plan

  ```bash
  terraform apply plan
  ```

8. You should see the normal terraform output building Kubernetes, setting up pods, containers, and monitoring
9. The final output will be 'public_ip: [IP4 Address]'
10 Use curl or your favorite browser to access "http://[IP4 Address]"
11. the result should be:

  ```json
  [{"greeting":"Hello World!"}]
  ```
