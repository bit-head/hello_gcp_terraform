# Use the slim debian/python base image
FROM python:slim

# Update package repositories and install required packages
RUN apt update && apt install -y pkg-config libicu-dev build-essential cmake

# Set the working directory
WORKDIR /app

# Copy files to the working directory
COPY app/ /app

# Ensure build env for CXX (required for wheel)
ENV CXX=g++
# Install app requirements
RUN pip install -r ./requirements.txt
# Start the application
CMD ["/bin/bash", "/app/gunicorn.sh"]

