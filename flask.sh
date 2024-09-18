#!/bin/bash
# Update and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip
pip3 install flask

# Create a simple Flask app
cat <<EOF > /home/azureuser/app.py
from flask import Flask
import socket

app = Flask(__name__)

@app.route('/')
def hello_world():
    hostname = socket.gethostname()
    return f'Hello, {hostname}!'

if __name__ == '__main__':
    app.run(host='0.0.0.0')
EOF

# Run the Flask app
nohup python3 /home/azureuser/app.py &
