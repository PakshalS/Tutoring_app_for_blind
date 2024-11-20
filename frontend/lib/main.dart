// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'screens/voice_command_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Voice Command App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const VoiceCommandScreen(),
//     );
//   }
// }

//for data population

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
