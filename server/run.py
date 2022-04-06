import os

from flask import Flask, request, jsonify
from flask_cors import CORS

print("\n\n\n\n-------------------------GO !---------------------------\n\n\n\n")

app = Flask(__name__)
CORS(app)


# app.add_url_rule('/', view_func=m.root)


# @app.route('/')
# def home():
#     return "Home"

@app.route('/api/', methods=['POST'])
def get_stuff():
    input_json = request.get_json(force=True)
    # force=True, above, is necessary if another developer
    # forgot to set the MIME type to 'application/json'
    print('data from client:', input_json)
    dictToReturn = {'answer':42}
    return jsonify(dictToReturn)

app.secret_key = os.urandom(12)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000, debug=True)

entry_command = 'gunicorn -b 0.0.0.0:8000 dashboard.main:app'
