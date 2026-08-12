import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
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
              // PermissionUpdated state, but we should be loading new data soon
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              controller: _tabController,
              children: [
                UsersTab(
                  users: users,
                  permissions: permissions,
                ),
                RolesTab(roles: roles, permissions: permissions),
              ],
            );
          } else if (state is PermissionInitial) {
            // Load initial data
            context.read<PermissionCubit>().loadData();
            return const Center(child: CircularProgressIndicator());
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

  const UsersTab({
    super.key,
    required this.users,
    required this.permissions,
  });

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
                subtitle: Text(
                  user.isActive == true ? 'فعال' : 'غیرفعال',
                  style: TextStyle(
                    color: user.isActive == true ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: MyDecorations.cardDecoration,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.isActive == true
                                          ? 'کاربر در حال حاضر فعال است'
                                          : 'کاربر در حال حاضر غیرفعال است',
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.isActive == true
                                          ? 'برای غیرفعال کردن دکمه سمت راست را فشار دهید'
                                          : 'برای فعال کردن دکمه سمت راست را فشار دهید',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: user.user != null
                                    ? () {
                                        final nextState = !(user.isActive == true);
                                        context
                                            .read<PermissionCubit>()
                                            .updateUserStatus(
                                              username: user.user!,
                                              isActive: nextState,
                                            );
                                      }
                                    : null,
                                icon: Icon(
                                  user.isActive == true
                                      ? Icons.person_off
                                      : Icons.person,
                                ),
                                style: MyDecorations.mainButtom.copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                    user.isActive == true
                                        ? Colors.red
                                        : SolidColors.accentColor,
                                  ),
                                ),
                                label: Text(
                                  user.isActive == true ? 'غیرفعال کردن' : 'فعال کردن',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
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
        .hasAccess;
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
                    onPressed: () async {
                      final List<Map<String, dynamic>> permList = [];
                      tempPermissions.forEach((code, hasAccess) {
                        permList.add({
                          'grant_type': hasAccess ? 'ALLOW' : 'DENY',
                          'permission': code,
                        });
                      });
                      if (user.id != null) {
                        await cubit.updateUserPermissions(
                          userId: user.id!,
                          permissions: permList,
                        );
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
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
              child: ExpansionTile(
                title: Text(role.name ?? ''),
                subtitle: Text(role.description ?? ''),
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
                            value: _hasPermission(role, perm.code ?? ''),
                            onChanged: (value) {
                              _showEditDialog(ctx, role, permissions);
                            },
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              _showEditDialog(ctx, role, permissions),
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

  bool _hasPermission(RoleModel role, String code) {
    final perm = role.permission?.data
        ?.firstWhere(
          (p) => p.name == code,
          orElse: () => PermissionItemModel(hasAccess: 0, name: ''),
        )
        .hasAccess;
    return perm == 1;
  }

  void _showEditDialog(
    BuildContext context,
    RoleModel role,
    List<PermissionListModel> allPermissions,
  ) {
    final cubit = context.read<PermissionCubit>();
    final Map<String, bool> tempPermissions = {};

    for (var perm in allPermissions) {
      tempPermissions[perm.code!] = _hasPermission(role, perm.code!);
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
                    onPressed: () async {
                      final List<Map<String, dynamic>> permList = [];
                      tempPermissions.forEach((code, hasAccess) {
                        permList.add({
                          'grant_type': hasAccess ? 'ALLOW' : 'DENY',
                          'permission': code,
                        });
                      });
                      await cubit.updateRolePermissions(
                        roleName: role.name!,
                        permissions: permList,
                      );
                      if (dialogContext.mounted) {
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
