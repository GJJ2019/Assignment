import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _monitorAuthState();
  }

  void _monitorAuthState() {
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user == null) {
        emit(Unauthenticated());
      }
    } catch (e) {
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(cleanMessage));
    }
  }

  Future<void> loginAnonymously() async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInAnonymously();
      if (user == null) {
        emit(Unauthenticated());
      }
    } catch (e) {
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(cleanMessage));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
    } catch (e) {
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(cleanMessage));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
