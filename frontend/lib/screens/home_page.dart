import 'package:flutter/material.dart';
import 'chapter_list_page.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_page.dart';
import '../screens/chat_screen.dart';
import '../services/current_location_service.dart';
import '../widgets/voice_wrapper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    CurrentLocationService.setPage('home');

    return VoiceWrapper(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black
              ], // Premium gradient background
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700], // High contrast
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 10,
                        shadowColor:
                            Colors.yellow[300]!.withOpacity(0.5), // Glow effect
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChapterListPage()),
                        );
                      },
                      child: const Text(
                        "View Chapters",
                        style: TextStyle(
                          fontSize: 28, // Large text for accessibility
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 1.2, // Premium typography
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700], // High contrast
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 10,
                        shadowColor:
                            Colors.yellow[300]!.withOpacity(0.5), // Glow effect
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                        );
                      },
                      child: const Text(
                        "DoubtBOT",
                        style: TextStyle(
                          fontSize: 28, // Large text for accessibility
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 1.2, // Premium typography
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.yellow[700], // Bright, contrasting color
          title: const Text(
            "Home",
            style: TextStyle(
              fontSize: 30, // Large text for accessibility
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.2, // Premium typography
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.logout,
              size: 36, // Larger icon for accessibility
              color: Colors.black,
            ),
            onPressed: () {
              authService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
      ),
    );
  }
}
