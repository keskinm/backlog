import os

from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from bson.json_util import dumps

from server.db.queries import get_status, dict_format_documents, update_backlog as _update_backlog

app = Flask(__name__)
CORS(app)


# app.add_url_rule('/', view_func=m.root, methods=['POST', 'GET'])


# @app.route('/')
# def home():
#     return "Home"

@app.route('/api/get_stuff', methods=['POST'])
def get_stuff():
    input_json = request.get_json(force=True)
    print('data from client:', input_json)
    dictToReturn = {'answer':str(42)}
    return jsonify(dictToReturn)

@app.route('/api/update_backlog', methods=['POST'])
def update_backlog():
    input_json = request.get_json(force=True)
    print(input_json)
    _update_backlog(input_json)
    return jsonify({})

@app.route('/api/get_backlog', methods=['GET'])
def get_backlog():
    status = get_status()
    r = []
    client = MongoClient(port=27017)
    db = client.backlog_db
    epics_collection = db.epics
    cursor = epics_collection.find({})
    for document in cursor:
        # r.append(dumps(document))
        print(status[document["_id"]])
        document["status"] = status[document["_id"]]
        r.append(document)
    return jsonify(r)

@app.route('/api/get_formatted_backlog', methods=['GET'])
def get_formatted_backlog():
    r = dict_format_documents()
    return jsonify(dumps(r))

app.secret_key = os.urandom(12)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000, debug=True)

entry_command = 'gunicorn -b 0.0.0.0:8000 dashboard.main:app'
