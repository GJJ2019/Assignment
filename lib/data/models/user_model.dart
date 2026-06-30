import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
    );
  }

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl];
}
