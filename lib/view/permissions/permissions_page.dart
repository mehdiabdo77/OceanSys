import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/model/permission_list_model.dart';
import 'package:ocean_sys/model/role_model.dart';
import 'cubit/permission_cubit.dart';
import 'cubit/permission_state.dart';
import 'widgets/users_tab.dart';
import 'widgets/roles_tab.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت دسترسی‌ها'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'کاربران'),
            Tab(text: 'نقش‌ها'),
          ],
        ),
      ),
      body: BlocConsumer<PermissionCubit, PermissionState>(
        listener: (context, state) {
          if (state is UserStatusUpdated) {
            Get.snackbar(
              'موفق',
              state.message,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
            );
          } else if (state is PermissionError) {
            Get.snackbar(
              'خطا',
              state.message,
              backgroundColor: Colors.red.withOpacity(0.8),
              colorText: Colors.white,
            );
          }
        },
        builder: (context, state) {
          if (state is PermissionLoading || state is PermissionUpdating) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PermissionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PermissionCubit>().loadData(),
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            );
          } else if (state is PermissionLoaded ||
              state is PermissionUpdated ||
              state is UserStatusUpdated) {
            late final List<UserModel> users;
            late final List<RoleModel> roles;
            late final List<PermissionListModel> permissions;
            if (state is PermissionLoaded) {
              users = state.users;
              roles = state.roles;
              permissions = state.permissions;
            } else if (state is PermissionUpdated) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              controller: _tabController,
              children: [
                UsersTab(users: users, permissions: permissions),
                RolesTab(roles: roles, permissions: permissions),
              ],
            );
          } else if (state is PermissionInitial) {
            context.read<PermissionCubit>().loadData();
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox();
        },
      ),
    );
  }
}
