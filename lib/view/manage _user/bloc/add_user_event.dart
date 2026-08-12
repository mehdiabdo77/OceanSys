part of 'add_user_bloc.dart';

abstract class AddUserEvent {}

class FetchRolesEvent extends AddUserEvent {}

class SubmitAddUserEvent extends AddUserEvent {
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final bool isActive;
  final String role;

  SubmitAddUserEvent({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.isActive,
    required this.role,
  });
}
