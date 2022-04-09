import os

from flask import Flask, request, jsonify
from flask_cors import CORS
from bson.json_util import dumps

from server.db.queries import Queries

app = Flask(__name__)
CORS(app)

q = Queries()


@app.route('/api/get_stuff', methods=['POST'])
def get_stuff():
    input_json = request.get_json(force=True)
    print('data from client:', input_json)
    dictToReturn = {'answer': str(42)}
    return jsonify(dictToReturn)


@app.route('/api/update_backlog', methods=['POST'])
def update_backlog():
    input_json = request.get_json(force=True)
    print(input_json)
    q.update_backlog(input_json)
    return jsonify({})


@app.route('/api/get_backlog', methods=['GET'])
def get_backlog():
    return jsonify(q.get_backlog())


@app.route('/api/get_epics_bugs', methods=['GET'])
def get_epics_bugs():
    return jsonify(q.get_epics_bugs())


@app.route('/api/get_formatted_backlog', methods=['GET'])
def get_formatted_backlog():
    r = q.dict_format_documents()
    return jsonify(dumps(r))


@app.route('/api/get_bugs_epics', methods=['GET'])
def get_bugs_epics():
    r = q.get_bugs_epics()
    return jsonify(r)


@app.route('/api/add_document', methods=['POST'])
def add_document():
    input_json = request.get_json(force=True)
    q.add_document(input_json)
    return jsonify({})


@app.route('/api/delete_document', methods=['POST'])
def delete_document():
    input_json = request.get_json(force=True)
    q.delete_document(input_json)
    return jsonify({})


app.secret_key = os.urandom(12)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000, debug=True)

entry_command = 'gunicorn -b 0.0.0.0:8000 dashboard.main:app'
