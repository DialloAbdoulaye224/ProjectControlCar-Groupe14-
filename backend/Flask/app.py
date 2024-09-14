from flask import Flask, jsonify
from flask_socketio import SocketIO, emit
from flask_sqlalchemy import SQLAlchemy
import paho.mqtt.client as mqtt


app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
socketio = SocketIO(app)
db = SQLAlchemy(app)

class SensorData(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    sensor_type = db.Column(db.String(50))
    value = db.Column(db.String(50))
    timestamp = db.Column(db.DateTime, default=db.func.current_timestamp())

def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    client.subscribe("esp32/sonar")

def on_message(client, userdata, msg):
    print(msg.topic + " " + str(msg.payload))
    sensor_type = msg.topic.split('/')[1]
    value = msg.payload.decode()

    with app.app_context():
        data = SensorData(sensor_type=sensor_type, value=value)
        db.session.add(data)
        db.session.commit()
        # Emit the event to all clients
        socketio.emit('sensor_data', {'sensor_type': sensor_type, 'value': value})

mqtt_client = mqtt.Client()
mqtt_client.on_connect = on_connect
mqtt_client.on_message = on_message
mqtt_client.connect("192.168.191.178", 1883, 60)
mqtt_client.loop_start()

@app.route('/')
def index():
    return "MiniCar Backend"

@app.route('/data', methods=['GET'])
def get_data():
    sensor_data = SensorData.query.all()
    return jsonify([{'sensor_type': d.sensor_type, 'value': d.value, 'timestamp': d.timestamp} for d in sensor_data])

@app.route('/ultrasonic', methods=['GET'])
def get_ultrasonic_data():
    ultrasonic_data = SensorData.query.filter_by(sensor_type='sonar').all()
    return jsonify([{'sensor_type': d.sensor_type, 'value': d.value, 'timestamp': d.timestamp} for d in ultrasonic_data])

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    socketio.run(app, host='0.0.0.0', port=5000)