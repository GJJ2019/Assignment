import 'dart:async';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithGoogle();
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
        throw Exception('Google Sign-In cancelled by user');
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
        throw Exception('Firebase login returned no user profile');
      }
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }
}
