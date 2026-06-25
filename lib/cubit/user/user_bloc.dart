import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/cubit/user/user_state.dart';
import 'package:ocean_sys/data/repository/user_repository.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';

abstract class UserEvent {}

class UserFetchData extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<UserFetchData>(_onFetchData);
  }

  Future<void> _onFetchData(
    UserFetchData event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await repository.getUserData();
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError("خطا در دریافت اطلاعات"));
      }
    } catch (e) {
      emit(UserError("خطا در ارتباط با سرور: $e"));
    }
  }

  bool checkPermission(String value, UserModel user) {
    if (user.permission == null || user.permission?.data == null) {
      return false;
    }

    return user.permission!.data!.any(
      (element) => element.name == value && element.hasAccess == 1,
    );
  }
}