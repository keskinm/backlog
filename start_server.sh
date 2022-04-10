#!/bin/sh
service mongodb start
python3 -m server.db.init
python3 -m server.run