import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/model/UserModel/Permission_model.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';
import 'package:ocean_sys/model/permission_list_model.dart';
import 'package:ocean_sys/model/role_model.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/my_color.dart';
import '../cubit/permission_cubit.dart';
import '../cubit/permission_state.dart';

class UsersTab extends StatefulWidget {
  final List<UserModel> users;
  final List<PermissionListModel> permissions;
  final List<RoleModel> roles;

  const UsersTab({
    super.key,
    required this.users,
    required this.permissions,
    required this.roles,
  });

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  final Map<int, Map<String, bool>> _tempPermissionsMap = {};
  final Map<int, String?> _selectedRolesMap = {};

  bool _hasPermission(UserModel user, String code) {
    final perm = user.permission?.data
        ?.firstWhere(
          (p) => p.name == code,
          orElse: () => PermissionItemModel(hasAccess: 0, name: ''),
        )
        .hasAccess;
    return perm == 1;
  }

  Map<String, bool> _getUserPermissions(UserModel user) {
    if (user.id == null) return {};
    if (!_tempPermissionsMap.containsKey(user.id)) {
      final Map<String, bool> temp = {};
      for (var perm in widget.permissions) {
        temp[perm.code!] = _hasPermission(user, perm.code!);
      }
      _tempPermissionsMap[user.id!] = temp;
    }
    return _tempPermissionsMap[user.id!]!;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final userPerms = _getUserPermissions(user);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text('${user.firstName} ${user.lastName} (${user.user})'),
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
                              user.isActive == true
                                  ? 'غیرفعال کردن'
                                  : 'فعال کردن',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: MyDecorations.cardDecoration,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تغییر نقش کاربر:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value:
                                      _selectedRolesMap[user.id] ??
                                      (widget.roles.isNotEmpty
                                          ? widget.roles.first.name
                                          : null),
                                  decoration: MyDecorations.inputDecoration,
                                  items: widget.roles.map((role) {
                                    return DropdownMenuItem<String>(
                                      value: role.name,
                                      child: Text(role.name ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedRolesMap[user.id!] = val;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: user.user != null
                                    ? () {
                                        final roleToAssign =
                                            _selectedRolesMap[user.id] ??
                                            (widget.roles.isNotEmpty
                                                ? widget.roles.first.name
                                                : null);
                                        if (roleToAssign != null) {
                                          context
                                              .read<PermissionCubit>()
                                              .updateUserRole(
                                                username: user.user!,
                                                roleName: roleToAssign,
                                              );
                                        }
                                      }
                                    : null,
                                child: const Text('ثبت نقش'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'دسترسی‌ها:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (var perm in widget.permissions)
                      CheckboxListTile(
                        title: Text(perm.name ?? ''),
                        subtitle: Text(perm.description ?? ''),
                        value: userPerms[perm.code] ?? false,
                        onChanged: (value) {
                          setState(() {
                            userPerms[perm.code!] = value ?? false;
                          });
                        },
                      ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BlocBuilder<PermissionCubit, PermissionState>(
                        builder: (context, state) {
                          if (state is PermissionUpdating) {
                            return const CircularProgressIndicator();
                          }
                          return ElevatedButton(
                            onPressed: user.id != null
                                ? () async {
                                    final List<Map<String, dynamic>> permList =
                                        [];
                                    userPerms.forEach((code, hasAccess) {
                                      permList.add({
                                        'grant_type': hasAccess
                                            ? 'ALLOW'
                                            : 'DENY',
                                        'permission': code,
                                      });
                                    });
                                    await context
                                        .read<PermissionCubit>()
                                        .updateUserPermissions(
                                          userId: user.id!,
                                          permissions: permList,
                                        );
                                  }
                                : null,
                            child: const Text('ذخیره تغییرات دسترسی'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
