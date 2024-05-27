# "slim" debian/python base image
FROM python:slim

# all we need are flask and the google firetore module
RUN pip install flask gunicorn google-cloud-firestore

# Set the working directory
WORKDIR /app

# Copy python app to the working directory
COPY app/ /app

# ensure google auth env
ENV PORT=5000
ENV TIMEOUT=120
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/idm-challenge-424101-08d15a1468a7.json

# Start the application
CMD ["/bin/bash", "/app/launchit.sh"]
