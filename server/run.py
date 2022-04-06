import os

from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient

app = Flask(__name__)
CORS(app)


# app.add_url_rule('/', view_func=m.root)


# @app.route('/')
# def home():
#     return "Home"

@app.route('/api/get_stuff', methods=['POST'])
def get_stuff():
    input_json = request.get_json(force=True)
    print('data from client:', input_json)
    dictToReturn = {'answer':str(42)}
    return jsonify(dictToReturn)

@app.route('/api/get_backlog', methods=['GET'])
def get_backlog():
    client = MongoClient(port=27017)
    db = client.backlog_db

    return jsonify(db.epics)

app.secret_key = os.urandom(12)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000, debug=True)

entry_command = 'gunicorn -b 0.0.0.0:8000 dashboard.main:app'
