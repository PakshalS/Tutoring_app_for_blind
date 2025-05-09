import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user
  Future<Map<String, dynamic>> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': result.user, 'error': null};
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Use at least 6 characters.';
          break;
        default:
          errorMessage = 'An error occurred during registration.';
      }
      return {'user': null, 'error': errorMessage};
    } catch (e) {
      return {'user': null, 'error': 'An unexpected error occurred.'};
    }
  }

  // Sign in user
  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': result.user, 'error': null};
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials.';
          break;
        default:
          errorMessage = 'An error occurred during login.';
      }
      return {'user': null, 'error': errorMessage};
    } catch (e) {
      return {'user': null, 'error': 'An unexpected error occurred.'};
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  // Get current user
  User? get currentUser {
    return _auth.currentUser;
  }
}
