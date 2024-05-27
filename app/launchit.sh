#!/bin/bash

# Using WSGI Server
# as wrapper for flask 
gunicorn \
    --bind :${PORT} \
    --timeout ${TIMEOUT} \
    --log-level=debug \
    --access-logfile - \
    --error-logfile - \
    get_greeting:msg