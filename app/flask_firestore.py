#!/usr/bin/env python3

from flask import Flask, jsonify
from google.cloud import firestore

app = Flask(__name__)
db = firestore.Client()

@app.route('/message', methods=['GET'])
def get_data():
    collection = db.collection('message')

    docs = collection.stream()

    message = [doc.to_dict() for doc in docs]

    return jsonify(message)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
