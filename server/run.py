import os

from flask import Flask, request, jsonify
from flask_cors import CORS
from bson.json_util import dumps

from server.db.queries import Queries

app = Flask(__name__)
CORS(app)

q = Queries()


@app.route("/api/update_backlog", methods=["POST"])
def update_backlog():
    input_json = request.get_json(force=True)
    q.update_backlog(input_json)
    return jsonify({})


@app.route("/api/get_backlog", methods=["GET"])
def get_backlog():
    return jsonify(q.get_backlog())


@app.route("/api/get_epics_bugs", methods=["GET"])
def get_epics_bugs():
    return jsonify(q.get_epics_bugs())


@app.route("/api/get_formatted_backlog", methods=["GET"])
def get_formatted_backlog():
    r = q.dict_format_documents()
    return jsonify(dumps(r))


@app.route("/api/get_bugs_epics", methods=["GET"])
def get_bugs_epics():
    r = q.get_bugs_epics()
    return jsonify(r)


@app.route("/api/add_document", methods=["POST"])
def add_document():
    input_json = request.get_json(force=True)
    q.add_document(input_json)
    return jsonify({})


@app.route("/api/delete_document", methods=["POST"])
def delete_document():
    input_json = request.get_json(force=True)
    q.delete_document(input_json)
    return jsonify({})


@app.route("/api/reinitialize_database", methods=["GET"])
def reinitialize_database():
    q.reinitialize_database()
    return jsonify({})


app.secret_key = os.urandom(12)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
