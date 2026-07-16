part of 'add_user_bloc.dart';

abstract class AddUserState {}

class AddUserInitial extends AddUserState {}

class AddUserLoading extends AddUserState {}

class RolesLoadedState extends AddUserState {
  final List<RoleModel> roles;
  RolesLoadedState(this.roles);
}

class RolesErrorState extends AddUserState {
  final String message;
  RolesErrorState(this.message);
}

class AddUserSuccess extends AddUserState {
  final String message;
  AddUserSuccess(this.message);
}

class AddUserFailure extends AddUserState {
  final String error;
  AddUserFailure(this.error);
}
