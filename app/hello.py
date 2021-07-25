from flask import Flask
import boto3
from datetime import datetime

app = Flask(__name__)
dynamodb = boto3.resource('dynamodb')

def ddb_entry(name, time):
    table = dynamodb.Table('names')
    table.put_item(
        Item={
            'name': name,
            'time': time,
        }
    )


@app.route("/hello/<name>")
def hello(name):
    ddb_entry(name, datetime.now())
    return f'Hello {name}\n'

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')