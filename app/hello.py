from flask import Flask
import boto3
from datetime import datetime

app = Flask(__name__)
dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')
table = dynamodb.Table('hello-app')

def ddb_entry(name, time):
    table.put_item(
        Item={
            'name': name,
            'time': time,
        }
    )

@app.route("/")
def hello():
    return f'Hello\n'

@app.route("/hello/<name>")
def hello_name(name):
    ddb_entry(name, str(datetime.now()))
    return f'Hello {name}\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)