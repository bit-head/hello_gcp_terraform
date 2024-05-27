# Hello World Web Application

This document outlines the setup, deployment, and functionality of a highly-available web application that when queried with a "GET" function via HTTP, message text is returned that reads 'hello world'. 

## Project Requirements

- Google Cloud Platform Free Tier: https://cloud.google.com/free/docs/gcp-free-tier
- Deployed using Infrastructure-as-Code (IaC)
-- Cloud Deployment Manager, Terraform, Pulumi, etc.
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
- Google Cloud Firestore
- Google Cloud SDK (for local development and deployment)

## Application Overview

The application is built using Flask; a lightweight web application framework in Python, and served with Gunicorn; a Python WSGI HTTP Server for *NIX applications. This application is designed to connect to Google Firestore, a NoSQL document database built for automatic scaling, high performance, and ease of application development.

## Infrastructure as Code

For this project's requirements, terraform is the obvious choice. Terraform is used to configure and deploy the required infrastructure to Google Cloud. In this case, a free-tier account was used to demonstrate a basic implementation to meet the requirements with very low initial cost.  

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

## Setup and Configuration
**NOTE:** This is an implementation for a home machine outside of Google Cloud's infrastructure. 

- Sign in to Google and download your credentials
- Ensure Google Cloud SDK installed (debian-based system)

```
## Download Googles GPG Key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
```
```
## Ensure key and Google repo is included in your apt repo lists
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```
```
## Install Google Cloud SDK (required) and GKE Cloud Auth (if you want to play with kubectl)
sudo apt update && sudo apt -y install google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin
```
- Ensure Neccessary Google APIs are installed

% 




### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-repository/flask-firestore.git
   cd flask-firestore