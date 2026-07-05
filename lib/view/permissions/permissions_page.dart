import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/my_color.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/model/UserModel/Permission_model.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/model/permission_list_model.dart';
import 'package:ocean_sys/model/role_model.dart';
import 'cubit/permission_cubit.dart';
import 'cubit/permission_state.dart';

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
      body: BlocBuilder<PermissionCubit, PermissionState>(
        builder: (context, state) {
          if (state is PermissionLoading) {
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
          } else if (state is PermissionLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                UsersTab(users: state.users, permissions: state.permissions),
                RolesTab(roles: state.roles, permissions: state.permissions),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class UsersTab extends StatelessWidget {
  final List<UserModel> users;
  final List<PermissionListModel> permissions;

  const UsersTab({super.key, required this.users, required this.permissions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Builder(
          builder: (ctx) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text(
                  '${user.firstName} ${user.lastName} (${user.user})',
                ),
                subtitle: Text(user.isActive == true ? 'فعال' : 'غیرفعال'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var perm in permissions)
                          CheckboxListTile(
                            title: Text(perm.name ?? ''),
                            subtitle: Text(perm.description ?? ''),
                            value: _hasPermission(user, perm.code ?? ''),
                            onChanged: (value) {
                              _showEditDialog(ctx, user, permissions);
                            },
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              _showEditDialog(ctx, user, permissions),
                          child: const Text('ویرایش دسترسی‌ها'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _hasPermission(UserModel user, String code) {
    final perm = user.permission?.data
        ?.firstWhere(
          (p) => p.name == code,
          orElse: () => PermissionItemModel(hasAccess: 0, name: ''),
        )
        ?.hasAccess;
    return perm == 1;
  }

  void _showEditDialog(
    BuildContext context,
    UserModel user,
    List<PermissionListModel> allPermissions,
  ) {
    final cubit = context.read<PermissionCubit>();
    final Map<String, bool> tempPermissions = {};

    for (var perm in allPermissions) {
      tempPermissions[perm.code!] = _hasPermission(user, perm.code!);
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text('ویرایش دسترسی‌های ${user.firstName} ${user.lastName}'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var perm in allPermissions)
                    CheckboxListTile(
                      title: Text(perm.name ?? ''),
                      subtitle: Text(perm.description ?? ''),
                      value: tempPermissions[perm.code],
                      onChanged: (value) {
                        setDialogState(() {
                          tempPermissions[perm.code!] = value ?? false;
                        });
                      },
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('انصراف'),
              ),
              BlocBuilder<PermissionCubit, PermissionState>(
                bloc: cubit,
                builder: (ctx, state) {
                  if (state is PermissionUpdating) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final List<Map<String, dynamic>> permList = [];
                      tempPermissions.forEach((code, hasAccess) {
                        permList.add({
                          'grant_type': hasAccess ? 'ALLOW' : 'DENY',
                          'permission': code,
                        });
                      });
                      if (user.id != null) {
                        cubit.updateUserPermissions(
                          userId: user.id!,
                          permissions: permList,
                        );
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: const Text('ذخیره'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class RolesTab extends StatelessWidget {
  final List<RoleModel> roles;
  final List<PermissionListModel> permissions;

  const RolesTab({super.key, required this.roles, required this.permissions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return Builder(
          builder: (ctx) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(role.name ?? ''),
                subtitle: Text(role.description ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(ctx, role, permissions),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    RoleModel role,
    List<PermissionListModel> allPermissions,
  ) {
    final cubit = context.read<PermissionCubit>();
    final Map<String, bool> tempPermissions = {};

    for (var perm in allPermissions) {
      tempPermissions[perm.code!] = false; // Default to false for roles
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text('ویرایش دسترسی‌های ${role.name}'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var perm in allPermissions)
                    CheckboxListTile(
                      title: Text(perm.name ?? ''),
                      subtitle: Text(perm.description ?? ''),
                      value: tempPermissions[perm.code],
                      onChanged: (value) {
                        setDialogState(() {
                          tempPermissions[perm.code!] = value ?? false;
                        });
                      },
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('انصراف'),
              ),
              BlocBuilder<PermissionCubit, PermissionState>(
                bloc: cubit,
                builder: (ctx, state) {
                  if (state is PermissionUpdating) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final List<Map<String, dynamic>> permList = [];
                      tempPermissions.forEach((code, hasAccess) {
                        permList.add({
                          'grant_type': hasAccess ? 'ALLOW' : 'DENY',
                          'permission': code,
                        });
                      });
                      cubit.updateRolePermissions(
                        roleName: role.name!,
                        permissions: permList,
                      );
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('ذخیره'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
