@echo off
call venv\Scripts\activate
set FLASK_APP=application.py
set FLASK_ENV=development
flask run --host=0.0.0.0 --port=8000
