import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/cubit/user/user_state.dart';
import 'package:ocean_sys/data/repository/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<void> getUserData() async {
    emit(UserLoading());
    try {
      final user = await _repository.getUserData();
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError("خطا در دریافت اطلاعات"));
      }
    } catch (e) {
      emit(UserError("خطا در ارتباط با سرور: $e"));
    }
  }

  bool checkPermission(String value) {
    if (state is! UserLoaded) {
      return false;
    }

    final user = (state as UserLoaded).user;
    if (user.permission == null || user.permission?.data == null) {
      return false;
    }

    return user.permission!.data!.any(
      (element) => element.name == value && element.hasAccess == 1,
    );
  }
}
