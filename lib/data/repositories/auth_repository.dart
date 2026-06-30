import 'dart:async';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInAnonymously();
  Future<void> signOut();
  UserModel? get currentUser;
  Stream<UserModel?> get authStateChanges;
}

class HybridAuthRepository implements AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _useMock = true;
  UserModel? _mockUser;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  HybridAuthRepository() {
    _init();
  }

  void _init() {
    try {
      // If Firebase core isn't configured/initialized, this will throw
      final auth = FirebaseAuth.instance;
      _useMock = false;
      auth.authStateChanges().listen((firebaseUser) {
        if (firebaseUser != null) {
          _authStateController.add(UserModel.fromFirebaseUser(firebaseUser));
        } else {
          _authStateController.add(null);
        }
      });
    } catch (e) {
      _useMock = true;
      _authStateController.add(null);
    }
  }

  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      final code = e.code.toLowerCase();
      if (code == 'invalid-credential') {
        return 'The login credentials are invalid or have expired.';
      }
      if (code == 'user-disabled') {
        return 'This user account has been disabled by an administrator.';
      }
      if (code == 'operation-not-allowed') {
        return 'Google Sign-In is not enabled on the authentication server.';
      }
      if (code == 'network-request-failed') {
        return 'Network request failed. Please check your internet connection.';
      }
      if (code == 'invalid-api-key') {
        return 'Firebase API key configuration is invalid.';
      }
      return e.message ?? 'A Firebase authentication error occurred.';
    } else if (e is PlatformException) {
      final code = e.code.toLowerCase();
      if (code == 'sign_in_canceled' || code == '12501') {
        return 'Sign-In cancelled by user.';
      }
      if (code == 'network_error' || code == '7') {
        return 'Network connection error. Please check your internet connection.';
      }
      if (code == 'developer_error' || code == '10') {
        return 'Developer configuration error. Please verify SHA-1 fingerprints in the Firebase Console.';
      }
      if (code == 'sign_in_failed' || code == '12500') {
        return 'Google Sign-In failed. Please verify your device Google Play services.';
      }
      return e.message ?? 'Google Sign-In failed (${e.code}).';
    }

    final message = e.toString();
    if (message.contains('canceled') ||
        message.contains('cancelled') ||
        message.contains('12501')) {
      return 'Sign-In cancelled by user.';
    }
    if (message.contains('10') ||
        message.contains('developer_error') ||
        message.contains('DeveloperError')) {
      return 'Developer configuration error. Please verify SHA-1 fingerprints in the Firebase Console.';
    }
    if (message.contains('7') ||
        message.contains('network_error') ||
        message.contains('NetworkError')) {
      return 'Network connection error. Please check your internet connection.';
    }
    if (message.contains('12500') ||
        message.contains('sign_in_failed') ||
        message.contains('SignInFailed')) {
      return 'Google Sign-In failed. Please verify Google Play services on your device.';
    }

    return 'Authentication error: $message';
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  UserModel? get currentUser {
    if (_useMock) {
      return _mockUser;
    }
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser != null ? UserModel.fromFirebaseUser(firebaseUser) : null;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 1500)); // Simulate network latency
      _mockUser = const UserModel(
        uid: 'mock_uid_123',
        displayName: 'John Doe',
        email: 'john.doe@gmail.com',
        photoUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
      );
      _authStateController.add(_mockUser);
      return _mockUser;
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        throw Exception('Sign-In cancelled by user.');
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final user = UserModel.fromFirebaseUser(firebaseUser);
        _authStateController.add(user);
        return user;
      } else {
        throw Exception('Firebase login returned no user profile.');
      }
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 1000)); // Simulate network latency
      _mockUser = const UserModel(
        uid: 'mock_guest_uid_999',
        displayName: 'Guest User',
        email: 'guest@alive.app',
        photoUrl: null,
      );
      _authStateController.add(_mockUser);
      return _mockUser;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final user = UserModel.fromFirebaseUser(firebaseUser);
        _authStateController.add(user);
        return user;
      } else {
        throw Exception('Anonymous login returned no user profile.');
      }
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  @override
  Future<void> signOut() async {
    if (_useMock) {
      _mockUser = null;
      _authStateController.add(null);
      return;
    }
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      _authStateController.add(null);
    } catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }
}
