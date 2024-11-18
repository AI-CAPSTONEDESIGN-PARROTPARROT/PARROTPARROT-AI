#!/bin/bash
# source venv/bin/activate
export FLASK_APP=application.py
export FLASK_ENV=development
flask run --host=0.0.0.0 --port=8000

# chmod +x start_flask.sh
# ./start_flask.sh
