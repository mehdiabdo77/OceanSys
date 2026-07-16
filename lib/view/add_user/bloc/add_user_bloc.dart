import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/data/repository/permission_repository.dart';
import 'package:ocean_sys/data/repository/user_repository.dart';
import 'package:ocean_sys/model/role_model.dart';

part 'add_user_event.dart';
part 'add_user_state.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final UserRepository userRepository;
  final PermissionRepository permissionRepository;
  
  List<RoleModel> rolesList = [];

  AddUserBloc({
    required this.userRepository,
    required this.permissionRepository,
  }) : super(AddUserInitial()) {
    on<FetchRolesEvent>(_onFetchRoles);
    on<SubmitAddUserEvent>(_onSubmitAddUser);
  }

  Future<void> _onFetchRoles(
    FetchRolesEvent event,
    Emitter<AddUserState> emit,
  ) async {
    emit(AddUserLoading());
    try {
      final roles = await permissionRepository.getRoles();
      if (roles != null) {
        rolesList = roles;
        emit(RolesLoadedState(roles));
      } else {
        emit(RolesErrorState("خطا در دریافت لیست نقش‌ها"));
      }
    } catch (e) {
      emit(RolesErrorState(e.toString()));
    }
  }

  Future<void> _onSubmitAddUser(
    SubmitAddUserEvent event,
    Emitter<AddUserState> emit,
  ) async {
    emit(AddUserLoading());
    try {
      final response = await userRepository.registerUser(
        username: event.username,
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
        isActive: event.isActive,
        role: event.role,
      );

      if (response != null && response['success'] == true) {
        emit(AddUserSuccess(response['message']));
      } else {
        emit(AddUserFailure(response?['message'] ?? "خطای نامشخص"));
      }
    } catch (e) {
      emit(AddUserFailure(e.toString()));
    }
  }
}
