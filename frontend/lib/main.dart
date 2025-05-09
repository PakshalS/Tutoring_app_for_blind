import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/widgets/auth_wrapper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 👈 Attach it here
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Exam Preparation Platform', // Updated title for accessibility
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(), // Use AuthWrapper to handle auth state
    );
  }
}
