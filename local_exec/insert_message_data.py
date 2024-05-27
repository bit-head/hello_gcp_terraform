#!/usr/bin/env python3

from google.cloud import firestore

collection = 'message'
document = 'greetings'

greeting = {
    'greeting': 'Hello World!'
}

db = firestore.Client()

def set_message(collection, document, greeting):
    doc_ref = db.collection(collection).document(document)
    doc_ref.set(greeting)

    return 'Collection and document created successfully', 200

if __name__ == '__main__':
    set_message(collection, document, greeting) 
