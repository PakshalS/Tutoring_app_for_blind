import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dashboard_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  VoiceCommandScreenState createState() => VoiceCommandScreenState();
}

class VoiceCommandScreenState extends State<VoiceCommandScreen>
    with WidgetsBindingObserver {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = '';
  final FlutterTts _flutterTts = FlutterTts();
  late Future<void> _firebaseInitialization; // Initialize Firebase Future

  @override
  void initState() {
    super.initState();
    _firebaseInitialization = _initializeFirebase(); // Initialize Firebase
    _requestPermission(); // Request permission at the start
    _speech = stt.SpeechToText();
    _flutterTts.setLanguage("en-US");
    WidgetsBinding.instance.addObserver(this); // Add observer for app lifecycle
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when screen is disposed
    _speech.stop(); // Stop listening when the widget is disposed
    super.dispose();
  }

  // Handle the app lifecycle events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reset listening state when the app is resumed
      setState(() {
        _isListening = false;
        _command = '';
      });
    }
  }

  Future<void> _requestPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            _command = result.recognizedWords;
            if (_command.toLowerCase() == "go forward") {
              _flutterTts.speak("Navigating to Dashboard");

              // Stop listening and reset state before navigation
              _speech.stop();
              setState(() {
                _isListening = false;
              });

              Future.delayed(const Duration(seconds: 2), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
                );
              });
            }
          });
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Command'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future:
            _firebaseInitialization, // Use FutureBuilder for Firebase status
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Command: $_command',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.yellow), // High contrast text
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _listen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.yellow, // High contrast button color
                      foregroundColor: Colors.black, // High contrast text color
                    ),
                    child: Text(_isListening ? 'Listening...' : 'Give Command'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _flutterTts.speak("Navigating to Dashboard");

                      // Stop listening and reset state before navigation
                      _speech.stop();
                      setState(() {
                        _isListening = false;
                      });

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardScreen()),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // High contrast manual navigation button
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Go to Dashboard"),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error initializing Firebase'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      backgroundColor: Colors.black, // High contrast background
    );
  }
}
