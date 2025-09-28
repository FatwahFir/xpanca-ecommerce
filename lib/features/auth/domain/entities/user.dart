import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String role;

  const User({
    required this.id,
    required this.username,
    required this.role,
  });

  @override
  List<Object?> get props => [id, username, role];
}
