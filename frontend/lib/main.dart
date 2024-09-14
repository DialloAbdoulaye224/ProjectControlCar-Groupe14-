//CODE FONCTIONNEL PRIME
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ControlCar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: CarGameHomePage(),
    );
  }
}
class CarGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarGameHomePage(),
    );
  }
}

class CarGameHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icon.png'), // Image de fond
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo du jeu
                Text(
                  "Bienvenue sur ControlCar!",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center, // Centre 
                ),
                SizedBox(height: 50),
                // Bouton "Start"
                ElevatedButton(
                  onPressed: () {
                    // Naviguer vers la page ModeSelectionPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ModeSelectionPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: Color.fromARGB(255, 57, 109, 207), // Couleur du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Démarrer',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Bouton "Options"
                TextButton(
                  onPressed: () {
                    _showOptionsDialog(context); // Ouvre le popup
                  },
                  child: Text(
                    'A propos',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour afficher le popup d'options
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('A propos'),
          content: Text('Bienvenue sur l application ControlCar, cette application à pour but de contrôle une voiture Freenove dotée d une crate esp32'),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le popup
              },
            ),
          ],
        );
      },
    );
  }
}

class ModeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez votre option'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/page.jpg'), // Image de fond 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Carte pour le mode téléguide
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.directions_car, size: 50, color: Colors.blueAccent),
                      title: Text('Téléguider', style: TextStyle(fontSize: 24)),
                      subtitle: Text('Contrôlez le véhicule manuellement.'),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Commande pour activer la caméra
                          final startCameraCommand = {
                            'cmd': 9,
                            'data': 1
                          };

                          final channel = WebSocketChannel.connect(
                            Uri.parse('ws://192.168.139.92/ws'),
                          );

                          // Envoyer la commande pour activer la caméra
                          channel.sink.add(jsonEncode(startCameraCommand));

                          // Naviguer vers la page de contrôle après l'activation de la caméra
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Couleur de fond du bouton
                          disabledBackgroundColor: Colors.blueAccent, // Couleur du texte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        child: Text(
                          'Démarrer',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Carte pour le mode autonome
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.auto_awesome, size: 50, color: Colors.greenAccent),
                      title: Text('Autonome', style: TextStyle(fontSize: 24)),
                      subtitle: Text('Detecte et suit la ligne de manière autonome.'),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AutonomousModePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.white, // Couleur de fond du bouton
                         backgroundColor: Colors.greenAccent, // Couleur du texte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.greenAccent, width: 2),
                        ),
                        child: Text(
                          'Démarrer',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AutonomousModePage extends StatefulWidget {
  @override
  _AutonomousModePageState createState() => _AutonomousModePageState();
}

class _AutonomousModePageState extends State<AutonomousModePage> {
  late MqttServerClient mqttClient;
  late WebSocketChannel webSocketChannel;

  String mqttBroker = '192.168.139.91'; // l'IP de du broker MQTT
  String websocketUrl = 'ws://192.168.139.92/ws'; // URL de du WebSocket

  String _sensorValue = 'Waiting for data...';
  Timer? _rotationTimer; // Timer pour gérer les rotations
  bool _isRotating = false; // État pour suivre si la voiture est en rotation

  @override
  void initState() {
    super.initState();
    connect();

    mqttClient.updates!.listen((messages) {
      final mqtt.MqttPublishMessage mqttMessage = messages[0].payload as mqtt.MqttPublishMessage;
      final payload = mqtt.MqttPublishPayload.bytesToStringAsString(mqttMessage.payload.message);

      setState(() {
        _sensorValue = payload;
      });

      print('Received sensor value: $payload'); // Affichage pour le débogage

      //  les valeurs du capteur pour contrôler la voiture
      final sensorValue = double.tryParse(payload);
      if (sensorValue != null) {
        if (sensorValue == 2) {
          print('Sensor value is 2, starting car'); // Débogage
          startCar();
        } else if (sensorValue == 1) {
          print('Sensor value is 1, turning left'); // Débogage
          turnLeft();
        } else if (sensorValue == 4) {
          print('Sensor value is 4, turning right'); // Débogage
          turnRight();
        } else if (sensorValue == 6) {
          print('Sensor value is 6, turning sharply right'); // Débogage
          turnSharpRight();
        } else if (sensorValue == 3) {
          print('Sensor value is 3, turning sharply left'); // Débogage
          turnSharpLeft();
        } else if (sensorValue == 0 || sensorValue == 7) {
          print('Sensor value is 0 or 7, rotating left and right'); // Débogage
          startRotations();
        } else {
          print('Sensor value is not 1, 2, 3, 4, 6, 0, or 7, stopping car'); // Débogage
          stopCar();
        }
      } else {
        print('Invalid sensor value received'); // Débogage
        stopCar();
      }
    });
  }

  void connect() async {
    // Connexion au MQTT
    mqttClient = MqttServerClient(mqttBroker, 'flutter_client');
    mqttClient.port = 1883;
    mqttClient.logging(on: false);
    mqttClient.keepAlivePeriod = 60;
    mqttClient.onDisconnected = onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .withWillQos(mqtt.MqttQos.atMostOnce);
    mqttClient.connectionMessage = connMess;

    try {
      await mqttClient.connect();
      print('Connected to MQTT');
      mqttClient.subscribe('esp32/track', mqtt.MqttQos.atMostOnce);
    } catch (e) {
      print('Failed to connect to MQTT: $e');
      mqttClient.disconnect();
    }

    // Connexion au WebSocket
    webSocketChannel = WebSocketChannel.connect(Uri.parse(websocketUrl));
    webSocketChannel.stream.listen((message) {
      print('WebSocket message: $message');
      //  les messages WebSocket si nécessaire
    });
  }

  void sendWebSocketCommand(Map<String, dynamic> command) {
    webSocketChannel.sink.add(jsonEncode(command));
    print('Sent WebSocket command: ${jsonEncode(command)}');
  }

  void startCar() {
    final command = {
      'cmd': 1,
      'data': [500, 500, 500, 500]
    };
    sendWebSocketCommand(command);
  }

  void stopCar() {
    final command = {
      'cmd': 1,
      'data': [0, 0, 0, 0]
    };
    sendWebSocketCommand(command);
  }

  void turnLeft() {
    final command = {
      'cmd': 1,
      'data': [-1000, -1000, 1000, 1000]
    };
    sendWebSocketCommand(command);
  }

  void turnRight() {
    final command = {
      'cmd': 1,
      'data': [1000, 1000, -1000, -1000]
    };
    sendWebSocketCommand(command);
  }

  void turnSharpLeft() {
    final command = {
      'cmd': 1,
      'data': [-1000, -1000, 1000, 1000]
    };
    sendWebSocketCommand(command);
  }

  void turnSharpRight() {
    final command = {
      'cmd': 1,
      'data': [1000, 1000, -1000, -1000]
    };
    sendWebSocketCommand(command);
  }

  void startRotations() {
    if (_isRotating) return; // Ne pas démarrer une nouvelle rotation si une rotation est déjà en cours

    const rotationDuration = Duration(seconds: 2); // Durée totale pour chaque rotation (60°)
    const pauseDuration = Duration(milliseconds: 500); // Pause entre les changements

    _isRotating = true;

    // une rotation à gauche
    turnSharpLeft();

    //  un timer pour tourner à gauche pendant 60°
    _rotationTimer = Timer(rotationDuration, () {
      if (_sensorValue == '0' || _sensorValue == '7') {
        // Si la valeur du capteur n'a pas changé, tourner à droite
        turnSharpRight();
        
        //  un timer pour revenir à droite pendant 60°
        _rotationTimer = Timer(rotationDuration, () {
          // Arrêt de  la rotation
          stopCar();
          _isRotating = false;
        });
      } else {
        // Arrête de la rotation si la valeur du capteur a changé
        stopCar();
        _isRotating = false;
      }
    });
  }

  void onDisconnected() {
    print('MQTT Disconnected');
  }

  @override
  void dispose() {
    mqttClient.disconnect();
    webSocketChannel.sink.close();
    _rotationTimer?.cancel(); //Annulation du timer lors de la fermeture
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode Autonome'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 238, 238, 238)!, Color.fromARGB(255, 255, 255, 255)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Valeur du capteur : $_sensorValue',
                  style: TextStyle(fontSize: 24, color: Colors.blueGrey[700], fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: startCar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Démarrer la voiture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: stopCar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Arrêter la voiture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel channel;
  Timer? _timer;
  double lastX = 0;
  double lastY = 0;
  bool isStopped = false;
  int sendInterval = 100; // Intervalle d'envoi en millisecondes (0.1 seconde)
  double ultrasonicDistance = 0.0; // Variable pour la distance ultrasonique

  late MqttServerClient mqttClient;

  @override
  void initState() {
    super.initState();
    _setupChannel(); // Setup WebSocket connection
    _connectToMQTTBroker(); // Setup MQTT connection
    _timer = Timer.periodic(Duration(milliseconds: sendInterval), (_) {
      _sendCommand();
    });
  }

  void _setupChannel() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.139.92/ws'), // URL WebSocket
    );

    channel.stream.listen((event) {
      try {
        var message = jsonDecode(event);
        if (message is Map<String, dynamic>) {
          if (message['cmd'] == 9 && message['data'] == 1) {
            setState(() {
              // 
            });
          }
        } else {
          print('Message non valide reçu : $event');
        }
      } catch (e) {
        print('Erreur de décodage JSON : $e');
        print('Message reçu non traité : $event');
      }
    }, onError: (error) {
      print('Erreur WebSocket : $error');
    }, onDone: () {
      print('WebSocket fermé');
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 5), (_) {
        if (channel.closeCode == null) {
          _setupChannel(); // Relance la connexion
        }
      });
    });
  }

double totalDistance = 0.0; // Variable pour accumuler la distance totale
DateTime? lastUpdateTime;   // Pour suivre l'intervalle de temps

void _connectToMQTTBroker() async {
  mqttClient = MqttServerClient.withPort('192.168.139.91', 'flutter_client', 1883);

  mqttClient.logging(on: false);
  mqttClient.keepAlivePeriod = 30;
  mqttClient.onDisconnected = _onDisconnected;

  final connMessage = MqttConnectMessage()
      .withClientIdentifier('flutter_client')
      .startClean()
      .keepAliveFor(30)
      .withWillTopic('test/test')
      .withWillMessage('Disconnected')
      .withWillQos(MqttQos.atLeastOnce);

  mqttClient.connectionMessage = connMessage;

  try {
    await mqttClient.connect();
    print('MQTT client connected');

    mqttClient.subscribe('esp32/sonar', MqttQos.atMostOnce);

    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
      final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

      setState(() {
        ultrasonicDistance = double.tryParse(message) ?? 0.0;
      });

      if (ultrasonicDistance > 25.0) {
        _stopBuzzer();
      }
    });
  } catch (e) {
    print('MQTT client exception - $e');
  }
}

void _onDisconnected() {
  print('MQTT client disconnected');
}

void _sendCommand() {
  if (ultrasonicDistance <= 25.0 && lastY > 0) {
    _stopCar();
    _soundBuzzer();
    return;
  }

  int leftSpeed = _getSpeed(lastY + lastX);
  int rightSpeed = _getSpeed(lastY - lastX);

  final stopLEDCommand = {
    'cmd': 5,
    'data': [-9, 255, 0, 0]
  };
  final moveLEDCommand = {
    'cmd': 5,
    'data': [-9, 0, 0, 255]
  };

  if (leftSpeed == 0 && rightSpeed == 0) {
    if (!isStopped) {
      final stopCommand = {
        'cmd': 1,
        'data': [0, 0, 0, 0]
      };
      print('Sending stop command: ${jsonEncode(stopCommand)}');
      channel.sink.add(jsonEncode(stopCommand));
      print('Sending stop LED command: ${jsonEncode(stopLEDCommand)}');
      channel.sink.add(jsonEncode(stopLEDCommand));
      isStopped = true;
    }
    return;
  } else {
    if (isStopped) {
      print('Sending move LED command: ${jsonEncode(moveLEDCommand)}');
      channel.sink.add(jsonEncode(moveLEDCommand));
      isStopped = false;
    }
  }

  final command = {
    'cmd': 1,
    'data': [leftSpeed, leftSpeed, rightSpeed, rightSpeed]
  };

  print('Sending command: ${jsonEncode(command)}');
  channel.sink.add(jsonEncode(command));

  // Calcule de la distance parcourue à chaque commande envoyée
  _calculateDistance([leftSpeed, rightSpeed]);
}

// Fonction pour calculer la distance parcourue
void _calculateDistance(List<int> wheelSpeeds) {
  DateTime now = DateTime.now();
  
  if (lastUpdateTime != null) {
    // Temps écoulé en secondes
    double elapsedTime = now.difference(lastUpdateTime!).inSeconds / 3600.0; // Convertir en heures

    // Calculer la vitesse moyenne
    double totalSpeed = 0;
    for (int speed in wheelSpeeds) {
      totalSpeed += _convertToSpeed(speed);
    }
    double averageSpeed = totalSpeed / wheelSpeeds.length;

    // Calculer la distance parcourue
    double distance = averageSpeed * elapsedTime;
    totalDistance += distance; // Accumulation la distance totale
  }

  lastUpdateTime = now; // Mettre à jour l'heure du dernier calcul
}

// Conversion de la valeur des roues en km/h
double _convertToSpeed(int data) {
  return data / 100.0; // Exemple : 500 = 5 km/h, 1000 = 10 km/h
}

void _stopCar() {
  final stopCommand = {
    'cmd': 1,
    'data': [0, 0, 0, 0]
  };
  print('Sending stop command due to obstacle: ${jsonEncode(stopCommand)}');
  channel.sink.add(jsonEncode(stopCommand));

  final stopLEDCommand = {
    'cmd': 5,
    'data': [-9, 255, 0, 0]
  };
  print('Sending stop LED command due to obstacle: ${jsonEncode(stopLEDCommand)}');
  channel.sink.add(jsonEncode(stopLEDCommand));

  isStopped = true;
}

void _soundBuzzer() {
  final buzzerCommand = {
    'cmd': 7,
    'data': 1
  };
  print('Sending buzzer command due to obstacle: ${jsonEncode(buzzerCommand)}');
  channel.sink.add(jsonEncode(buzzerCommand));
}

void _stopBuzzer() {
  final stopBuzzerCommand = {
    'cmd': 7,
    'data': 0
  };
  print('Sending stop buzzer command: ${jsonEncode(stopBuzzerCommand)}');
  channel.sink.add(jsonEncode(stopBuzzerCommand));
}

int _getSpeed(double value) {
  if (value > 0.5) {
    return 1000;
  } else if (value > 0.2) {
    return 500;
  } else if (value < -0.5) {
    return -1000;
  } else if (value < -0.2) {
    return -500;
  }
  return 0;
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Mode manuel'),
      centerTitle: true,
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: WebView(
            initialUrl: 'http://192.168.139.92:7000', // URL de la camera --> URL webSocket
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
        Container(
          height: 270,
          width: 500,
          color: Colors.blue, 
          child: Column(
            children: [
              Expanded(
                child: Joystick(
                  mode: JoystickMode.all,
                  listener: (details) {
                    setState(() {
                      lastX = details.x;
                      lastY = details.y;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Distance to obstacle: ${ultrasonicDistance.toStringAsFixed(2)} cm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ultrasonicDistance <= 25.0 ? Colors.red : Colors.green,
                      ),
                    ),
                    SizedBox(height: 10), // Espacement
                    Text(
                      'Distance parcourue: ${totalDistance.toStringAsFixed(2)} km',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
// Code fonctionnel############# -- VPRIME

// import 'package:flutter/material.dart';
// import 'package:flutter_joystick/flutter_joystick.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import 'dart:convert';
// import 'dart:async';
// import 'package:mqtt_client/mqtt_client.dart' as mqtt;
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:mqtt_client/mqtt_client.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ControlCar',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.blue,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       home: CarGameHomePage(),
//     );
//   }
// }
// class CarGameApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CarGameHomePage(),
//     );
//   }
// }

// class CarGameHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Image de fond
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/icon.png'), // Image de fond (ajoute l'image dans le dossier assets)
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Centrer tout le contenu
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo du jeu (texte centré)
//                 Text(
//                   "Bienvenue sur ControlCar!",
//                   style: TextStyle(
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 10.0,
//                         color: Colors.black,
//                         offset: Offset(5.0, 5.0),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center, // Centrer le texte
//                 ),
//                 SizedBox(height: 50),
//                 // Bouton "Start"
//                 ElevatedButton(
//                   onPressed: () {
//                     // Naviguer vers la page ModeSelectionPage
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ModeSelectionPage()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//                     backgroundColor: Color.fromARGB(255, 57, 109, 207), // Couleur du bouton
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     'Démarrer',
//                     style: TextStyle(
//                       fontSize: 24,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 // Bouton "Options"
//                 TextButton(
//                   onPressed: () {
//                     _showOptionsDialog(context); // Ouvre le popup
//                   },
//                   child: Text(
//                     'A propos',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Fonction pour afficher le popup d'options
//   void _showOptionsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('A propos'),
//           content: Text('Ici vous pouvez modifier les paramètres du jeu.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Fermer'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Ferme le popup
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class ModeSelectionPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Choisissez votre option'),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/page.jpg'), // Image de fond (ajoute l'image dans le dossier assets)
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Carte pour le mode téléguide
//               Card(
//                 margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     ListTile(
//                       leading: Icon(Icons.directions_car, size: 50, color: Colors.blueAccent),
//                       title: Text('Téléguider', style: TextStyle(fontSize: 24)),
//                       subtitle: Text('Contrôlez le véhicule manuellement.'),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       alignment: Alignment.centerRight,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Commande pour activer la caméra
//                           final startCameraCommand = {
//                             'cmd': 9,
//                             'data': 1
//                           };

//                           final channel = WebSocketChannel.connect(
//                             Uri.parse('ws://192.168.139.92/ws'),
//                           );

//                           // Envoyer la commande pour activer la caméra
//                           channel.sink.add(jsonEncode(startCameraCommand));

//                           // Naviguer vers la page de contrôle après l'activation de la caméra
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => MyHomePage()),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white, // Couleur de fond du bouton
//                           disabledBackgroundColor: Colors.blueAccent, // Couleur du texte
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           side: BorderSide(color: Colors.blueAccent, width: 2),
//                         ),
//                         child: Text(
//                           'Démarrer',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               // Carte pour le mode autonome
//               Card(
//                 margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     ListTile(
//                       leading: Icon(Icons.auto_awesome, size: 50, color: Colors.greenAccent),
//                       title: Text('Autonome', style: TextStyle(fontSize: 24)),
//                       subtitle: Text('Detecte et suit la ligne de manière autonome.'),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       alignment: Alignment.centerRight,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => AutonomousModePage()),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                         disabledBackgroundColor: Colors.white, // Couleur de fond du bouton
//                          backgroundColor: Colors.greenAccent, // Couleur du texte
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           side: BorderSide(color: Colors.greenAccent, width: 2),
//                         ),
//                         child: Text(
//                           'Démarrer',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AutonomousModePage extends StatefulWidget {
//   @override
//   _AutonomousModePageState createState() => _AutonomousModePageState();
// }

// class _AutonomousModePageState extends State<AutonomousModePage> {
//   late MqttServerClient mqttClient;
//   late WebSocketChannel webSocketChannel;

//   String mqttBroker = '192.168.139.91'; // Remplacez par l'IP de votre broker MQTT
//   String websocketUrl = 'ws://192.168.139.92/ws'; // Remplacez par l'URL de votre WebSocket

//   String _sensorValue = 'Waiting for data...';
//   Timer? _rotationTimer; // Timer pour gérer les rotations
//   bool _isRotating = false; // État pour suivre si la voiture est en rotation

//   @override
//   void initState() {
//     super.initState();
//     connect();

//     mqttClient.updates!.listen((messages) {
//       final mqtt.MqttPublishMessage mqttMessage = messages[0].payload as mqtt.MqttPublishMessage;
//       final payload = mqtt.MqttPublishPayload.bytesToStringAsString(mqttMessage.payload.message);

//       setState(() {
//         _sensorValue = payload;
//       });

//       print('Received sensor value: $payload'); // Affichage pour le débogage

//       // Traitez les valeurs du capteur pour contrôler la voiture
//       final sensorValue = double.tryParse(payload);
//       if (sensorValue != null) {
//         if (sensorValue == 2) {
//           print('Sensor value is 2, starting car'); // Débogage
//           startCar();
//         } else if (sensorValue == 1) {
//           print('Sensor value is 1, turning left'); // Débogage
//           turnLeft();
//         } else if (sensorValue == 4) {
//           print('Sensor value is 4, turning right'); // Débogage
//           turnRight();
//         } else if (sensorValue == 6) {
//           print('Sensor value is 6, turning sharply right'); // Débogage
//           turnSharpRight();
//         } else if (sensorValue == 3) {
//           print('Sensor value is 3, turning sharply left'); // Débogage
//           turnSharpLeft();
//         } else if (sensorValue == 0 || sensorValue == 7) {
//           print('Sensor value is 0 or 7, rotating left and right'); // Débogage
//           startRotations();
//         } else {
//           print('Sensor value is not 1, 2, 3, 4, 6, 0, or 7, stopping car'); // Débogage
//           stopCar();
//         }
//       } else {
//         print('Invalid sensor value received'); // Débogage
//         stopCar();
//       }
//     });
//   }

//   void connect() async {
//     // Connexion au MQTT
//     mqttClient = MqttServerClient(mqttBroker, 'flutter_client');
//     mqttClient.port = 1883;
//     mqttClient.logging(on: false);
//     mqttClient.keepAlivePeriod = 60;
//     mqttClient.onDisconnected = onDisconnected;

//     final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .withWillQos(mqtt.MqttQos.atMostOnce);
//     mqttClient.connectionMessage = connMess;

//     try {
//       await mqttClient.connect();
//       print('Connected to MQTT');
//       mqttClient.subscribe('esp32/track', mqtt.MqttQos.atMostOnce);
//     } catch (e) {
//       print('Failed to connect to MQTT: $e');
//       mqttClient.disconnect();
//     }

//     // Connexion au WebSocket
//     webSocketChannel = WebSocketChannel.connect(Uri.parse(websocketUrl));
//     webSocketChannel.stream.listen((message) {
//       print('WebSocket message: $message');
//       // Traitez les messages WebSocket si nécessaire
//     });
//   }

//   void sendWebSocketCommand(Map<String, dynamic> command) {
//     webSocketChannel.sink.add(jsonEncode(command));
//     print('Sent WebSocket command: ${jsonEncode(command)}');
//   }

//   void startCar() {
//     final command = {
//       'cmd': 1,
//       'data': [500, 500, 500, 500]
//     };
//     sendWebSocketCommand(command);
//   }

//   void stopCar() {
//     final command = {
//       'cmd': 1,
//       'data': [0, 0, 0, 0]
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnLeft() {
//     final command = {
//       'cmd': 1,
//       'data': [-1000, -1000, 1000, 1000]
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnRight() {
//     final command = {
//       'cmd': 1,
//       'data': [1000, 1000, -1000, -1000]
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnSharpLeft() {
//     final command = {
//       'cmd': 1,
//       'data': [-1000, -1000, 1000, 1000]
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnSharpRight() {
//     final command = {
//       'cmd': 1,
//       'data': [1000, 1000, -1000, -1000]
//     };
//     sendWebSocketCommand(command);
//   }

//   void startRotations() {
//     if (_isRotating) return; // Ne pas démarrer une nouvelle rotation si une rotation est déjà en cours

//     const rotationDuration = Duration(seconds: 2); // Durée totale pour chaque rotation (60°)
//     const pauseDuration = Duration(milliseconds: 500); // Pause entre les changements

//     _isRotating = true;

//     // Démarrer une rotation à gauche
//     turnSharpLeft();

//     // Créer un timer pour tourner à gauche pendant 60°
//     _rotationTimer = Timer(rotationDuration, () {
//       if (_sensorValue == '0' || _sensorValue == '7') {
//         // Si la valeur du capteur n'a pas changé, tourner à droite
//         turnSharpRight();
        
//         // Créer un timer pour revenir à droite pendant 60°
//         _rotationTimer = Timer(rotationDuration, () {
//           // Arrêter la rotation
//           stopCar();
//           _isRotating = false;
//         });
//       } else {
//         // Arrêter la rotation si la valeur du capteur a changé
//         stopCar();
//         _isRotating = false;
//       }
//     });
//   }

//   void onDisconnected() {
//     print('MQTT Disconnected');
//   }

//   @override
//   void dispose() {
//     mqttClient.disconnect();
//     webSocketChannel.sink.close();
//     _rotationTimer?.cancel(); // Assurez-vous d'annuler le timer lors de la fermeture
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mode Autonome'),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color.fromARGB(255, 238, 238, 238)!, Color.fromARGB(255, 255, 255, 255)!],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 8,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   'Valeur du capteur : $_sensorValue',
//                   style: TextStyle(fontSize: 24, color: Colors.blueGrey[700], fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: startCar,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: Text(
//                   'Démarrer la voiture',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: stopCar,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: Text(
//                   'Arrêter la voiture',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late WebSocketChannel channel;
//   Timer? _timer;
//   double lastX = 0;
//   double lastY = 0;
//   bool isStopped = false;
//   int sendInterval = 100; // Intervalle d'envoi en millisecondes (0.1 seconde)
//   double ultrasonicDistance = 0.0; // Variable pour la distance ultrasonique

//   late MqttServerClient mqttClient;

//   @override
//   void initState() {
//     super.initState();
//     _setupChannel(); // Setup WebSocket connection
//     _connectToMQTTBroker(); // Setup MQTT connection
//     _timer = Timer.periodic(Duration(milliseconds: sendInterval), (_) {
//       _sendCommand();
//     });
//   }

//   void _setupChannel() {
//     channel = WebSocketChannel.connect(
//       Uri.parse('ws://192.168.139.92/ws'), // Replace with your WebSocket server address
//     );

//     channel.stream.listen((event) {
//       try {
//         var message = jsonDecode(event);
//         if (message is Map<String, dynamic>) {
//           if (message['cmd'] == 9 && message['data'] == 1) {
//             setState(() {
//               // Update state based on message
//             });
//           }
//         } else {
//           print('Message non valide reçu : $event');
//         }
//       } catch (e) {
//         print('Erreur de décodage JSON : $e');
//         print('Message reçu non traité : $event');
//       }
//     }, onError: (error) {
//       print('Erreur WebSocket : $error');
//     }, onDone: () {
//       print('WebSocket fermé');
//       _timer?.cancel();
//       _timer = Timer.periodic(Duration(seconds: 5), (_) {
//         if (channel.closeCode == null) {
//           _setupChannel(); // Réessayer la connexion
//         }
//       });
//     });
//   }

//   void _connectToMQTTBroker() async {
//     mqttClient = MqttServerClient.withPort('192.168.139.91', 'flutter_client', 1883);

//     mqttClient.logging(on: false);
//     mqttClient.keepAlivePeriod = 30;
//     mqttClient.onDisconnected = _onDisconnected;

//     final connMessage = MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .startClean()
//         .keepAliveFor(30)
//         .withWillTopic('test/test')
//         .withWillMessage('Disconnected')
//         .withWillQos(MqttQos.atLeastOnce);

//     mqttClient.connectionMessage = connMessage;

//     try {
//       await mqttClient.connect();
//       print('MQTT client connected');

//       mqttClient.subscribe('esp32/sonar', MqttQos.atMostOnce);

//       mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
//         final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
//         final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

//         setState(() {
//           ultrasonicDistance = double.tryParse(message) ?? 0.0;
//         });

//         if (ultrasonicDistance > 25.0) {
//           _stopBuzzer();
//         }
//       });
//     } catch (e) {
//       print('MQTT client exception - $e');
//     }
//   }

//   void _onDisconnected() {
//     print('MQTT client disconnected');
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     channel.sink.close(status.goingAway);
//     mqttClient.disconnect();
//     super.dispose();
//   }

//   void _sendCommand() {
//     if (ultrasonicDistance <= 25.0 && lastY > 0) {
//       _stopCar();
//       _soundBuzzer();
//       return;
//     }

//     int leftSpeed = _getSpeed(lastY + lastX);
//     int rightSpeed = _getSpeed(lastY - lastX);

//     final stopLEDCommand = {
//       'cmd': 5,
//       'data': [-9, 255, 0, 0]
//     };
//     final moveLEDCommand = {
//       'cmd': 5,
//       'data': [-9, 0, 0, 255]
//     };

//     if (leftSpeed == 0 && rightSpeed == 0) {
//       if (!isStopped) {
//         final stopCommand = {
//           'cmd': 1,
//           'data': [0, 0, 0, 0]
//         };
//         print('Sending stop command: ${jsonEncode(stopCommand)}');
//         channel.sink.add(jsonEncode(stopCommand));
//         print('Sending stop LED command: ${jsonEncode(stopLEDCommand)}');
//         channel.sink.add(jsonEncode(stopLEDCommand));
//         isStopped = true;
//       }
//       return;
//     } else {
//       if (isStopped) {
//         print('Sending move LED command: ${jsonEncode(moveLEDCommand)}');
//         channel.sink.add(jsonEncode(moveLEDCommand));
//         isStopped = false;
//       }
//     }

//     final command = {
//       'cmd': 1,
//       'data': [leftSpeed, leftSpeed, rightSpeed, rightSpeed]
//     };

//     print('Sending command: ${jsonEncode(command)}');
//     channel.sink.add(jsonEncode(command));
//   }

//   void _stopCar() {
//     final stopCommand = {
//       'cmd': 1,
//       'data': [0, 0, 0, 0]
//     };
//     print('Sending stop command due to obstacle: ${jsonEncode(stopCommand)}');
//     channel.sink.add(jsonEncode(stopCommand));

//     final stopLEDCommand = {
//       'cmd': 5,
//       'data': [-9, 255, 0, 0]
//     };
//     print('Sending stop LED command due to obstacle: ${jsonEncode(stopLEDCommand)}');
//     channel.sink.add(jsonEncode(stopLEDCommand));

//     isStopped = true;
//   }

//   void _soundBuzzer() {
//     final buzzerCommand = {
//       'cmd': 7,
//       'data': 1
//     };
//     print('Sending buzzer command due to obstacle: ${jsonEncode(buzzerCommand)}');
//     channel.sink.add(jsonEncode(buzzerCommand));
//   }

//   void _stopBuzzer() {
//     final stopBuzzerCommand = {
//       'cmd': 7,
//       'data': 0
//     };
//     print('Sending stop buzzer command: ${jsonEncode(stopBuzzerCommand)}');
//     channel.sink.add(jsonEncode(stopBuzzerCommand));
//   }

//   int _getSpeed(double value) {
//     if (value > 0.5) {
//       return 1000;
//     } else if (value > 0.2) {
//       return 500;
//     } else if (value < -0.5) {
//       return -1000;
//     } else if (value < -0.2) {
//       return -500;
//     }
//     return 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mode manuel'),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child: WebView(
//               initialUrl: 'http://192.168.139.92:7000', // Replace with your camera stream URL
//               javascriptMode: JavascriptMode.unrestricted,
//             ),
//           ),
//           Container(
//             height: 270,
//             width: 500,
//             color: Colors.blue, // Ajoute un arrière-plan bleu
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Joystick(
//                     mode: JoystickMode.all,
//                     listener: (details) {
//                       setState(() {
//                         lastX = details.x;
//                         lastY = details.y;
//                       });
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Distance to obstacle: ${ultrasonicDistance.toStringAsFixed(2)} cm',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: ultrasonicDistance <= 25.0 ? Colors.red : Colors.green,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ---------------------V4(autonomie FONCTIONNELLE)
// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart' as mqtt;
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';
// import 'dart:async'; // Importer pour utiliser Timer

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MQTT & WebSocket App',
//       home: SensorDisplay(),
//     );
//   }
// }

// class SensorDisplay extends StatefulWidget {
//   @override
//   _SensorDisplayState createState() => _SensorDisplayState();
// }

// class _SensorDisplayState extends State<SensorDisplay> {
//   late MqttServerClient mqttClient;
//   late WebSocketChannel webSocketChannel;

//   String mqttBroker = '192.168.191.91'; // Remplacez par l'IP de votre broker MQTT
//   String websocketUrl = 'ws://192.168.191.92/ws'; // Remplacez par l'URL de votre WebSocket

//   String _sensorValue = 'Waiting for data...';
//   Timer? _rotationTimer; // Timer pour gérer les rotations
//   Timer? _stopRotationTimer; // Timer pour arrêter les rotations après un certain temps
//   bool _isRotating = false; // État pour suivre si la voiture est en rotation

//   @override
//   void initState() {
//     super.initState();
//     connect();

//     mqttClient.updates!.listen((messages) {
//       final mqtt.MqttPublishMessage mqttMessage = messages[0].payload as mqtt.MqttPublishMessage;
//       final payload = mqtt.MqttPublishPayload.bytesToStringAsString(mqttMessage.payload.message);

//       setState(() {
//         _sensorValue = payload;
//       });

//       print('Received sensor value: $payload'); // Affichage pour le débogage

//       // Traitez les valeurs du capteur pour contrôler la voiture
//       final sensorValue = double.tryParse(payload);
//       if (sensorValue != null) {
//         if (sensorValue == 2) {
//           print('Sensor value is 2, starting car'); // Débogage
//           startCar();
//         } else if (sensorValue == 1) {
//           print('Sensor value is 1, turning left'); // Débogage
//           turnLeft();
//         } else if (sensorValue == 4) {
//           print('Sensor value is 4, turning right'); // Débogage
//           turnRight();
//         } else if (sensorValue == 6) {
//           print('Sensor value is 6, turning sharply right'); // Débogage
//           turnSharpRight();
//         } else if (sensorValue == 3) {
//           print('Sensor value is 3, turning sharply left'); // Débogage
//           turnSharpLeft();
//         } else if (sensorValue == 0 || sensorValue == 7) {
//           print('Sensor value is 0 or 7, rotating left and right'); // Débogage
//           startRotations();
//         } else {
//           print('Sensor value is not 1, 2, 3, 4, 6, 0, or 7, stopping car'); // Débogage
//           stopCar();
//         }
//       } else {
//         print('Invalid sensor value received'); // Débogage
//         stopCar();
//       }
//     });
//   }

//   void connect() async {
//     // Connexion au MQTT
//     mqttClient = MqttServerClient(mqttBroker, 'flutter_client');
//     mqttClient.port = 1883;
//     mqttClient.logging(on: false);
//     mqttClient.keepAlivePeriod = 60;
//     mqttClient.onDisconnected = onDisconnected;

//     final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .withWillQos(mqtt.MqttQos.atMostOnce);
//     mqttClient.connectionMessage = connMess;

//     try {
//       await mqttClient.connect();
//       print('Connected to MQTT');
//       mqttClient.subscribe('esp32/track', mqtt.MqttQos.atMostOnce);
//     } catch (e) {
//       print('Failed to connect to MQTT: $e');
//       mqttClient.disconnect();
//     }

//     // Connexion au WebSocket
//     webSocketChannel = WebSocketChannel.connect(Uri.parse(websocketUrl));
//     webSocketChannel.stream.listen((message) {
//       print('WebSocket message: $message');
//       // Traitez les messages WebSocket si nécessaire
//     });
//   }

//   void sendWebSocketCommand(Map<String, dynamic> command) {
//     webSocketChannel.sink.add(jsonEncode(command));
//     print('Sent WebSocket command: ${jsonEncode(command)}');
//   }

//   void startCar() {
//     final command = {
//       'cmd': 1,
//       'data': [500, 500, 500, 500]
//     };
//     sendWebSocketCommand(command);
//   }

//   void stopCar() {
//     final command = {
//       'cmd': 1,
//       'data': [0, 0, 0, 0]
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnLeft() {
//     // Ajustez les valeurs pour tourner à gauche
//     final command = {
//       'cmd': 1,
//       'data': [-1000, -1000, 1000, 1000] // Exemple de valeurs, ajustez selon vos besoins
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnRight() {
//     // Ajustez les valeurs pour tourner à droite
//     final command = {
//       'cmd': 1,
//       'data': [1000, 1000, -1000, -1000] // Exemple de valeurs, ajustez selon vos besoins
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnSharpLeft() {
//     // Ajustez les valeurs pour un virage serré à gauche
//     final command = {
//       'cmd': 1,
//       'data': [-1000, -1000, 1000, 1000] // Ajustez les valeurs selon la rotation souhaitée
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnSharpRight() {
//     // Ajustez les valeurs pour un virage serré à droite
//     final command = {
//       'cmd': 1,
//       'data': [1000, 1000, -1000, -1000] // Ajustez les valeurs selon la rotation souhaitée
//     };
//     sendWebSocketCommand(command);
//   }

//   void startRotations() {
//     if (_isRotating) return; // Ne pas démarrer une nouvelle rotation si une rotation est déjà en cours

//     const rotationDuration = Duration(seconds: 2); // Durée totale pour chaque rotation (60°)
//     const pauseDuration = Duration(milliseconds: 500); // Pause entre les changements

//     _isRotating = true;

//     // Démarrer une rotation à gauche
//     turnSharpLeft();

//     // Créer un timer pour tourner à gauche pendant 60°
//     _rotationTimer = Timer(rotationDuration, () {
//       if (_sensorValue == '0' || _sensorValue == '7') {
//         // Si la valeur du capteur n'a pas changé, tourner à droite
//         turnSharpRight();
        
//         // Créer un timer pour revenir à droite pendant 60°
//         _rotationTimer = Timer(rotationDuration, () {
//           // Arrêter la rotation
//           stopCar();
//           _isRotating = false;
//         });
//       } else {
//         // Arrêter la rotation si la valeur du capteur a changé
//         stopCar();
//         _isRotating = false;
//       }
//     });
//   }

//   void onDisconnected() {
//     print('MQTT Disconnected');
//   }

//   @override
//   void dispose() {
//     mqttClient.disconnect();
//     webSocketChannel.sink.close();
//     _rotationTimer?.cancel(); // Assurez-vous d'annuler le timer lors de la fermeture
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MQTT & WebSocket App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Sensor Value:',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Text(
//               _sensorValue,
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: startCar,
//                   child: Text('Start Car Manually'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: stopCar,
//                   child: Text('Stop Car'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// -----------------------V3(FONCTIONNELLE)
// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart' as mqtt;
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MQTT & WebSocket App',
//       home: SensorDisplay(),
//     );
//   }
// }

// class SensorDisplay extends StatefulWidget {
//   @override
//   _SensorDisplayState createState() => _SensorDisplayState();
// }

// class _SensorDisplayState extends State<SensorDisplay> {
//   late MqttServerClient mqttClient;
//   late WebSocketChannel webSocketChannel;

//   String mqttBroker = '192.168.191.91'; // Remplacez par l'IP de votre broker MQTT
//   String websocketUrl = 'ws://192.168.191.92/ws'; // Remplacez par l'URL de votre WebSocket

//   String _sensorValue = 'Waiting for data...';

//   @override
//   void initState() {
//     super.initState();
//     connect();

//     mqttClient.updates!.listen((messages) {
//       final mqtt.MqttPublishMessage mqttMessage = messages[0].payload as mqtt.MqttPublishMessage;
//       final payload = mqtt.MqttPublishPayload.bytesToStringAsString(mqttMessage.payload.message);

//       setState(() {
//         _sensorValue = payload;
//       });

//       print('Received sensor value: $payload'); // Affichage pour le débogage

//       // Traitez les valeurs du capteur pour contrôler la voiture
//       final sensorValue = double.tryParse(payload);
//       if (sensorValue != null) {
//         if (sensorValue == 2) {
//           print('Sensor value is 2, starting car'); // Débogage
//           startCar();
//         } else if (sensorValue == 1) {
//           print('Sensor value is 1, turning left'); // Débogage
//           turnLeft();
//         } else if (sensorValue == 4) {
//           print('Sensor value is 4, turning right'); // Débogage
//           turnRight();
//         } else {
//           print('Sensor value is not 1, 2, or 4, stopping car'); // Débogage
//           stopCar();
//         }
//       } else {
//         print('Invalid sensor value received'); // Débogage
//         stopCar();
//       }
//     });
//   }

//   void connect() async {
//     // Connexion au MQTT
//     mqttClient = MqttServerClient(mqttBroker, 'flutter_client');
//     mqttClient.port = 1883;
//     mqttClient.logging(on: false);
//     mqttClient.keepAlivePeriod = 60;
//     mqttClient.onDisconnected = onDisconnected;

//     final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .withWillQos(mqtt.MqttQos.atMostOnce);
//     mqttClient.connectionMessage = connMess;

//     try {
//       await mqttClient.connect();
//       print('Connected to MQTT');
//       mqttClient.subscribe('esp32/track', mqtt.MqttQos.atMostOnce);
//     } catch (e) {
//       print('Failed to connect to MQTT: $e');
//       mqttClient.disconnect();
//     }

//     // Connexion au WebSocket
//     webSocketChannel = WebSocketChannel.connect(Uri.parse(websocketUrl));
//     webSocketChannel.stream.listen((message) {
//       print('WebSocket message: $message');
//       // Traitez les messages WebSocket si nécessaire
//     });
//   }

//   void sendWebSocketCommand(Map<String, dynamic> command) {
//     webSocketChannel.sink.add(jsonEncode(command));
//     print('Sent WebSocket command: ${jsonEncode(command)}');
//   }

//   void startCar() {
//     final command = {
//       'cmd': 1,
//       'data': [500, 500, 500, 500]
//     };
//     sendWebSocketCommand(command);
//   }

//   void stopCar() {
//     final command = {
//       'cmd': 1,
//       'data': [0, 0, 0, 0]
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnLeft() {
//     // Ajustez les valeurs pour tourner à gauche
//     final command = {
//       'cmd': 1,
//       'data': [-800, -800, 800, 800] // Exemple de valeurs, ajustez selon vos besoins
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnRight() {
//     // Ajustez les valeurs pour tourner à droite
//     final command = {
//       'cmd': 1,
//       'data': [800, 800, -800, -800] // Exemple de valeurs, ajustez selon vos besoins
//     };
//     sendWebSocketCommand(command);
//   }

//   void onDisconnected() {
//     print('MQTT Disconnected');
//   }

//   @override
//   void dispose() {
//     mqttClient.disconnect();
//     webSocketChannel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MQTT & WebSocket App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Sensor Value:',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Text(
//               _sensorValue,
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: startCar,
//                   child: Text('Start Car Manually'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: stopCar,
//                   child: Text('Stop Car'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// #############################V2
// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart' as mqtt;
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MQTT & WebSocket App',
//       home: SensorDisplay(),
//     );
//   }
// }

// class SensorDisplay extends StatefulWidget {
//   @override
//   _SensorDisplayState createState() => _SensorDisplayState();
// }

// class _SensorDisplayState extends State<SensorDisplay> {
//   late MqttServerClient mqttClient;
//   late WebSocketChannel webSocketChannel;

//   String mqttBroker = '192.168.191.91'; // Remplacez par l'IP de votre broker MQTT
//   String websocketUrl = 'ws://192.168.191.92/ws'; // Remplacez par l'URL de votre WebSocket

//   String _sensorValue = 'Waiting for data...';

//   @override
//   void initState() {
//     super.initState();
//     connect();

//     mqttClient.updates!.listen((messages) {
//       final mqtt.MqttPublishMessage mqttMessage = messages[0].payload as mqtt.MqttPublishMessage;
//       final payload = mqtt.MqttPublishPayload.bytesToStringAsString(mqttMessage.payload.message);

//       setState(() {
//         _sensorValue = payload;
//       });

//       print('Received sensor value: $payload'); // Affichage pour le débogage

//       // Traitez les valeurs du capteur pour contrôler la voiture
//       final sensorValue = double.tryParse(payload);
//       if (sensorValue != null) {
//         if (sensorValue == 2) {
//           print('Sensor value is 2, starting car'); // Débogage
//           startCar();
//         } else if (sensorValue == 1) {
//           print('Sensor value is 1, turning left'); // Débogage
//           turnLeft();
//         } else if (sensorValue == 4) {
//           print('Sensor value is 4, turning right'); // Débogage
//           turnRight();
//         } else {
//           print('Sensor value is not 1, 2, or 4, stopping car'); // Débogage
//           stopCar();
//         }
//       } else {
//         print('Invalid sensor value received'); // Débogage
//         stopCar();
//       }
//     });
//   }

//   void connect() async {
//     // Connexion au MQTT
//     mqttClient = MqttServerClient(mqttBroker, 'flutter_client');
//     mqttClient.port = 1883;
//     mqttClient.logging(on: false);
//     mqttClient.keepAlivePeriod = 60;
//     mqttClient.onDisconnected = onDisconnected;

//     final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .withWillQos(mqtt.MqttQos.atMostOnce);
//     mqttClient.connectionMessage = connMess;

//     try {
//       await mqttClient.connect();
//       print('Connected to MQTT');
//       mqttClient.subscribe('esp32/track', mqtt.MqttQos.atMostOnce);
//     } catch (e) {
//       print('Failed to connect to MQTT: $e');
//       mqttClient.disconnect();
//     }

//     // Connexion au WebSocket
//     webSocketChannel = WebSocketChannel.connect(Uri.parse(websocketUrl));
//     webSocketChannel.stream.listen((message) {
//       print('WebSocket message: $message');
//       // Traitez les messages WebSocket si nécessaire
//     });
//   }

//   void sendWebSocketCommand(Map<String, dynamic> command) {
//     webSocketChannel.sink.add(jsonEncode(command));
//     print('Sent WebSocket command: ${jsonEncode(command)}');
//   }

//   void startCar() {
//     final command = {
//       'cmd': 1,
//       'data': [500, 500, 500, 500]
//     };
//     sendWebSocketCommand(command);
//   }

//   void stopCar() {
//     final command = {
//       'cmd': 1,
//       'data': [0, 0, 0, 0]
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnLeft() {
//     // Ajustez les valeurs pour tourner à gauche
//     final command = {
//       'cmd': 1,
//       'data': [-800, -800, 800, 800] // Exemple de valeurs, ajustez selon vos besoins
//     };
//     sendWebSocketCommand(command);
//   }

//   void turnRight() {
//     // Ajustez les valeurs pour tourner à droite
//     final command = {
//       'cmd': 1,
//       'data': [800, 800, -800, -800] // Exemple de valeurs, ajustez selon vos besoins
//     };
//     sendWebSocketCommand(command);
//   }

//   void onDisconnected() {
//     print('MQTT Disconnected');
//   }

//   @override
//   void dispose() {
//     mqttClient.disconnect();
//     webSocketChannel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MQTT & WebSocket App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Sensor Value:',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Text(
//               _sensorValue,
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: startCar,
//                   child: Text('Start Car Manually'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: stopCar,
//                   child: Text('Stop Car'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ---------------------------------------V1
// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart' as mqtt;
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MQTT & WebSocket App',
//       home: SensorDisplay(),
//     );
//   }
// }

// class SensorDisplay extends StatefulWidget {
//   @override
//   _SensorDisplayState createState() => _SensorDisplayState();
// }

// class _SensorDisplayState extends State<SensorDisplay> {
//   late MqttServerClient mqttClient;
//   late WebSocketChannel webSocketChannel;

//   String mqttBroker = '192.168.191.91'; // Replace with your MQTT broker's IP
//   String websocketUrl = 'ws://192.168.191.92/ws'; // Replace with your WebSocket URL

//   String _sensorValue = 'Waiting for data...';

//   @override
//   void initState() {
//     super.initState();
//     connect();

//     mqttClient.updates!.listen((messages) {
//       final mqtt.MqttPublishMessage mqttMessage = messages[0].payload as mqtt.MqttPublishMessage;
//       final payload = mqtt.MqttPublishPayload.bytesToStringAsString(mqttMessage.payload.message);

//       setState(() {
//         _sensorValue = payload;
//       });

//       print('Received sensor value: $payload'); // Debug print

//       // Check if sensorValue is equal to 2 and control car movement
//       if (double.tryParse(payload) != null && double.parse(payload) == 2) {
//         print('Sensor value is 2, starting car'); // Debug print
//         startCar();
//       } else {
//         print('Sensor value is not 2, stopping car'); // Debug print
//         stopCar();
//       }
//     });
//   }

//   void connect() async {
//     // Connect to MQTT
//     mqttClient = MqttServerClient(mqttBroker, 'flutter_client');
//     mqttClient.port = 1883;
//     mqttClient.logging(on: false);
//     mqttClient.keepAlivePeriod = 60;
//     mqttClient.onDisconnected = onDisconnected;

//     final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .withWillQos(mqtt.MqttQos.atMostOnce);
//     mqttClient.connectionMessage = connMess;

//     try {
//       await mqttClient.connect();
//       print('Connected to MQTT');
//       mqttClient.subscribe('esp32/track', mqtt.MqttQos.atMostOnce);
//     } catch (e) {
//       print('Failed to connect to MQTT: $e');
//       mqttClient.disconnect();
//     }

//     // Connect to WebSocket
//     webSocketChannel = WebSocketChannel.connect(Uri.parse(websocketUrl));
//     webSocketChannel.stream.listen((message) {
//       print('WebSocket message: $message');
//       // Handle WebSocket messages if needed
//     });
//   }

//   void sendWebSocketCommand(Map<String, dynamic> command) {
//     webSocketChannel.sink.add(jsonEncode(command));
//     print('Sent WebSocket command: ${jsonEncode(command)}');
//   }

//   void startCar() {
//     final command = {
//       'cmd': 1,
//       'data': [500, 500, 500, 500]
//     };

//     sendWebSocketCommand(command);
//   }

//   void stopCar() {
//     final command = {
//       'cmd': 1,
//       'data': [0, 0, 0, 0]
//     };

//     sendWebSocketCommand(command);
//   }

//   void onDisconnected() {
//     print('MQTT Disconnected');
//   }

//   @override
//   void dispose() {
//     mqttClient.disconnect();
//     webSocketChannel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MQTT & WebSocket App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Sensor Value:',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Text(
//               _sensorValue,
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: startCar,
//                   child: Text('Start Car Manually'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: stopCar,
//                   child: Text('Stop Car'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // ------------------------------------------ CAMERA + LED + BUZZER + JOYSTICK + CAPTEUR(PREMIERE PARTIE DU PROJET FONCTIONNELLE)
// import 'package:flutter/material.dart';
// import 'package:flutter_joystick/flutter_joystick.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import 'dart:convert';
// import 'dart:async';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ControlCar',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.blue,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Colors.blue,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Bienvenue sur ControlCar!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 20),
//             Image.asset('assets/accueil.jpg', width: 500, height: 500),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ModeSelectionPage()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(200, 60),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//               child: Text('Suivant'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ModeSelectionPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Choisissez votre option'),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Colors.blue,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Commande pour activer la caméra
//                   final startCameraCommand = {
//                     'cmd': 9,
//                     'data': 1
//                   };

//                   final channel = WebSocketChannel.connect(
//                     Uri.parse('ws://192.168.191.92/ws'),
//                   );

//                   // Envoyer la commande pour activer la caméra
//                   channel.sink.add(jsonEncode(startCameraCommand));

//                   // Naviguer vers la page de contrôle après l'activation de la caméra
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyHomePage()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(200, 60),
//                   textStyle: TextStyle(fontSize: 18),
//                 ),
//                 child: Text('Téléguider'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AutonomousModePage()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(200, 60),
//                   textStyle: TextStyle(fontSize: 18),
//                 ),
//                 child: Text('Autonome'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AutonomousModePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mode Autonome'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 // Action pour démarrer le mode autonome
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green, // Couleur du bouton Start
//                 minimumSize: Size(200, 60),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//               child: Text('Start'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Action pour arrêter le mode autonome
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red, // Couleur du bouton Stop
//                 minimumSize: Size(200, 60),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//               child: Text('Stop'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late WebSocketChannel channel;
//   Timer? _timer;
//   double lastX = 0;
//   double lastY = 0;
//   bool isStopped = false;
//   int sendInterval = 100; // Intervalle d'envoi en millisecondes (0.1 seconde)
//   double ultrasonicDistance = 0.0; // Variable pour la distance ultrasonique

//   late MqttServerClient mqttClient;

//   @override
//   void initState() {
//     super.initState();
//     _setupChannel(); // Setup WebSocket connection
//     _connectToMQTTBroker(); // Setup MQTT connection
//     _timer = Timer.periodic(Duration(milliseconds: sendInterval), (_) {
//       _sendCommand();
//     });
//   }

//   void _setupChannel() {
//     channel = WebSocketChannel.connect(
//       Uri.parse('ws://192.168.191.92/ws'), // Replace with your WebSocket server address
//     );

//     channel.stream.listen((event) {
//       try {
//         var message = jsonDecode(event);
//         if (message is Map<String, dynamic>) {
//           if (message['cmd'] == 9 && message['data'] == 1) {
//             setState(() {
//               // Update state based on message
//             });
//           }
//         } else {
//           print('Message non valide reçu : $event');
//         }
//       } catch (e) {
//         print('Erreur de décodage JSON : $e');
//         print('Message reçu non traité : $event');
//       }
//     }, onError: (error) {
//       print('Erreur WebSocket : $error');
//     }, onDone: () {
//       print('WebSocket fermé');
//       _timer?.cancel();
//       _timer = Timer.periodic(Duration(seconds: 5), (_) {
//         if (channel.closeCode == null) {
//           _setupChannel(); // Réessayer la connexion
//         }
//       });
//     });
//   }

//   void _connectToMQTTBroker() async {
//     mqttClient = MqttServerClient.withPort('192.168.191.91', 'flutter_client', 1883);

//     mqttClient.logging(on: false);
//     mqttClient.keepAlivePeriod = 30;
//     mqttClient.onDisconnected = _onDisconnected;

//     final connMessage = MqttConnectMessage()
//         .withClientIdentifier('flutter_client')
//         .startClean()
//         .keepAliveFor(30)
//         .withWillTopic('test/test')
//         .withWillMessage('Disconnected')
//         .withWillQos(MqttQos.atLeastOnce);

//     mqttClient.connectionMessage = connMessage;

//     try {
//       await mqttClient.connect();
//       print('MQTT client connected');

//       mqttClient.subscribe('esp32/sonar', MqttQos.atMostOnce);

//       mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
//         final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
//         final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

//         setState(() {
//           ultrasonicDistance = double.tryParse(message) ?? 0.0;
//         });

//         if (ultrasonicDistance > 25.0) {
//           _stopBuzzer();
//         }
//       });
//     } catch (e) {
//       print('MQTT client exception - $e');
//     }
//   }

//   void _onDisconnected() {
//     print('MQTT client disconnected');
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     channel.sink.close(status.goingAway);
//     mqttClient.disconnect();
//     super.dispose();
//   }

//   void _sendCommand() {
//     if (ultrasonicDistance <= 25.0 && lastY > 0) {
//       _stopCar();
//       _soundBuzzer();
//       return;
//     }

//     int leftSpeed = _getSpeed(lastY + lastX);
//     int rightSpeed = _getSpeed(lastY - lastX);

//     final stopLEDCommand = {
//       'cmd': 5,
//       'data': [-9, 255, 0, 0]
//     };
//     final moveLEDCommand = {
//       'cmd': 5,
//       'data': [-9, 0, 0, 255]
//     };

//     if (leftSpeed == 0 && rightSpeed == 0) {
//       if (!isStopped) {
//         final stopCommand = {
//           'cmd': 1,
//           'data': [0, 0, 0, 0]
//         };
//         print('Sending stop command: ${jsonEncode(stopCommand)}');
//         channel.sink.add(jsonEncode(stopCommand));
//         print('Sending stop LED command: ${jsonEncode(stopLEDCommand)}');
//         channel.sink.add(jsonEncode(stopLEDCommand));
//         isStopped = true;
//       }
//       return;
//     } else {
//       if (isStopped) {
//         print('Sending move LED command: ${jsonEncode(moveLEDCommand)}');
//         channel.sink.add(jsonEncode(moveLEDCommand));
//         isStopped = false;
//       }
//     }

//     final command = {
//       'cmd': 1,
//       'data': [leftSpeed, leftSpeed, rightSpeed, rightSpeed]
//     };

//     print('Sending command: ${jsonEncode(command)}');
//     channel.sink.add(jsonEncode(command));
//   }

//   void _stopCar() {
//     final stopCommand = {
//       'cmd': 1,
//       'data': [0, 0, 0, 0]
//     };
//     print('Sending stop command due to obstacle: ${jsonEncode(stopCommand)}');
//     channel.sink.add(jsonEncode(stopCommand));

//     final stopLEDCommand = {
//       'cmd': 5,
//       'data': [-9, 255, 0, 0]
//     };
//     print('Sending stop LED command due to obstacle: ${jsonEncode(stopLEDCommand)}');
//     channel.sink.add(jsonEncode(stopLEDCommand));

//     isStopped = true;
//   }

//   void _soundBuzzer() {
//     final buzzerCommand = {
//       'cmd': 7,
//       'data': 1
//     };
//     print('Sending buzzer command due to obstacle: ${jsonEncode(buzzerCommand)}');
//     channel.sink.add(jsonEncode(buzzerCommand));
//   }

//   void _stopBuzzer() {
//     final stopBuzzerCommand = {
//       'cmd': 7,
//       'data': 0
//     };
//     print('Sending stop buzzer command: ${jsonEncode(stopBuzzerCommand)}');
//     channel.sink.add(jsonEncode(stopBuzzerCommand));
//   }

//   int _getSpeed(double value) {
//     if (value > 0.5) {
//       return 1000;
//     } else if (value > 0.2) {
//       return 500;
//     } else if (value < -0.5) {
//       return -1000;
//     } else if (value < -0.2) {
//       return -500;
//     }
//     return 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mode manuel'),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Expanded(
//             child: WebView(
//               initialUrl: 'http://192.168.191.92:7000', // Replace with your camera stream URL
//               javascriptMode: JavascriptMode.unrestricted,
//             ),
//           ),
//           Container(
//             height: 270,
//             width: 500,
//             color: Colors.blue, // Ajoute un arrière-plan bleu
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Joystick(
//                     mode: JoystickMode.all,
//                     listener: (details) {
//                       setState(() {
//                         lastX = details.x;
//                         lastY = details.y;
//                       });
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Distance to obstacle: ${ultrasonicDistance.toStringAsFixed(2)} cm',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: ultrasonicDistance <= 25.0 ? Colors.red : Colors.green,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
