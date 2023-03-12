from flask import Flask, request, render_template, jsonify
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import os
import csv
import time
app = Flask(__name__)

csv_file_path = os.path.join(os.getcwd(), 'grades.csv')

@app.route('/')
def index():
    return '<h1>Hello</h1>'

class CSVHandler(FileSystemEventHandler):
    def on_modified(self, event):
        time.sleep(1) # wait for the file to finish saving
        if event.src_path == csv_file_path:
            updated_csv = read_csv()
            send_csv_to_clients(updated_csv)

def send_csv_to_clients(csv_data):
    with app.test_request_context('/grades'):
        response = app.make_response(jsonify(csv_data))
        response.headers.add('Access-Control-Allow-Origin', '*')
        app.process_response(response)
        
def read_csv():
	with open(csv_file_path, 'r') as f:
		reader = csv.DictReader(f)
		rows = list(reader)
	return rows

@app.route('/hot')
def hot():
	pass

@app.route('/grades', methods=['GET'])
def grades():
    rows = read_csv()
    response = jsonify(rows)
    response.headers.add('Access-Control-Allow-Origin', '*')
    return response
    # return render_template('grades.html', data=rows)
@app.route('/command/<cmd>')
def command(cmd):
    return f'<h1>{cmd}</h1>'


if __name__ == '__main__':
    observer = Observer()
    observer.schedule(CSVHandler(), path=os.path.dirname(csv_file_path))
    observer.start()
    app.run(host="0.0.0.0")
