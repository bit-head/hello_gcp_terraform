# "slim" debian/python base image
FROM python:slim

# ensure required modules
RUN pip install flask google-cloud-firestore

# Install curl and gpg - we'll need them later
RUN apt update
RUN apt upgrade
RUN apt -y install curl gpg

# Set the working directory
WORKDIR /app

# Copy files to the working directory
COPY app/ /app

# Setup Google auth env
ENV GOOGLE_APPLICATION_CREDENTIALS="/app/idm-challenge-424101-08d15a1468a7.json"

# Start the application
CMD ["/usr/bin/env", "python3", "/app/flask_firestore.py"]

