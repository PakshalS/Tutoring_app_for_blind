import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/tts_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final TTSService _ttsService = TTSService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _ttsService.speak("Email and Password cannot be empty");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Email and Password cannot be empty",
            style: TextStyle(
              fontSize: 20, // Larger text for accessibility
              color: Colors.black, // High contrast
            ),
          ),
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
        ),
      );
      return;
    }

    final result =
        await _authService.registerWithEmailAndPassword(email, password);
    if (result['user'] != null) {
      _ttsService.speak("Registered successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Registration successful! Please log in.",
            style: TextStyle(
              fontSize: 20, // Larger text for accessibility
              color: Colors.black, // High contrast
            ),
          ),
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      final errorMessage = result['error'] ?? "An error occurred";
      _ttsService.speak(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(
              fontSize: 20, // Larger text for accessibility
              color: Colors.black, // High contrast
            ),
          ),
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // High-contrast black background
      appBar: AppBar(
        backgroundColor: Colors.yellow[700], // Bright yellow for contrast
        title: const Text(
          "Register",
          style: TextStyle(
            fontSize: 30, // Larger text for accessibility
            fontWeight: FontWeight.bold,
            color: Colors.black, // High contrast
            letterSpacing: 1.2, // Premium typography
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextField(
                controller: _emailController,
                style: TextStyle(
                  fontSize: 22, // Larger text for accessibility
                  color: Colors.yellow[700], // High contrast
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.yellow[700]!.withOpacity(0.8),
                  ),
                  filled: true,
                  fillColor: Colors.black87, // Dark input background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                    borderSide: BorderSide(
                      color: Colors.yellow[700]!, // Yellow border
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.yellow[700]!, // Yellow border
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color:
                          Colors.yellow[300]!, // Brighter yellow when focused
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Increased spacing
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextField(
                controller: _passwordController,
                style: TextStyle(
                  fontSize: 22, // Larger text for accessibility
                  color: Colors.yellow[700], // High contrast
                ),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.yellow[700]!.withOpacity(0.8),
                  ),
                  filled: true,
                  fillColor: Colors.black87, // Dark input background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                    borderSide: BorderSide(
                      color: Colors.yellow[700]!, // Yellow border
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.yellow[700]!, // Yellow border
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color:
                          Colors.yellow[300]!, // Brighter yellow when focused
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 30), // Increased spacing
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.yellow[700], // Bright yellow for contrast
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 40), // Larger touch area
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                  ),
                  elevation: 8, // Shadow for premium feel
                  shadowColor:
                      Colors.yellow[300]!.withOpacity(0.5), // Glow effect
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 24, // Larger text for accessibility
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // High contrast
                    letterSpacing: 1.2, // Premium typography
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Increased spacing
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    fontSize: 20, // Larger text for accessibility
                    color: Colors.yellow[700], // High contrast
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
