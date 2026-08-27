import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/model/UserModel/Permission_model.dart';
import 'package:ocean_sys/model/permission_list_model.dart';
import 'package:ocean_sys/model/role_model.dart';
import '../cubit/permission_cubit.dart';
import '../cubit/permission_state.dart';

class RolesTab extends StatefulWidget {
  final List<RoleModel> roles;
  final List<PermissionListModel> permissions;

  const RolesTab({super.key, required this.roles, required this.permissions});

  @override
  State<RolesTab> createState() => _RolesTabState();
}

class _RolesTabState extends State<RolesTab> {
  final Map<String, Map<String, bool>> _tempPermissionsMap = {};

  bool _hasPermission(RoleModel role, String code) {
    final normalizedCode = code.trim().toUpperCase();
    if (role.permissions != null && role.permissions!.isNotEmpty) {
      try {
        final perm = role.permissions!.firstWhere(
          (p) => (p.name ?? '').trim().toUpperCase() == normalizedCode,
          orElse: () => PermissionItemModel(hasAccess: false, name: ''),
        );
        final val = perm.hasAccess;
        if (val == true || val == 1 || val == 'true' || val == '1') {
          return true;
        }
      } catch (_) {}
    }
    if (role.permission?.data == null) return false;
    try {
      final perm = role.permission!.data!.firstWhere(
        (p) => (p.name ?? '').trim().toUpperCase() == normalizedCode,
        orElse: () => PermissionItemModel(hasAccess: false, name: ''),
      );
      final val = perm.hasAccess;
      if (val == true || val == 1 || val == 'true' || val == '1') {
        return true;
      }
    } catch (_) {}
    return false;
  }

  Map<String, bool> _getRolePermissions(RoleModel role) {
    final key = role.roleNameValue;
    if (key.isEmpty) return {};
    if (!_tempPermissionsMap.containsKey(key)) {
      final Map<String, bool> temp = {};
      for (var perm in widget.permissions) {
        temp[perm.code!] = _hasPermission(role, perm.code!);
      }
      _tempPermissionsMap[key] = temp;
    }
    return _tempPermissionsMap[key]!;
  }

  @override
  void didUpdateWidget(covariant RolesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tempPermissionsMap.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.roles.length,
      itemBuilder: (context, index) {
        final role = widget.roles[index];
        final rolePerms = _getRolePermissions(role);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(role.roleNameValue),
            subtitle: Text(role.description ?? ''),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        value: rolePerms[perm.code] ?? false,
                        onChanged: (value) {
                          setState(() {
                            rolePerms[perm.code!] = value ?? false;
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
                            onPressed: role.roleNameValue.isNotEmpty
                                ? () async {
                                    final List<Map<String, dynamic>> permList =
                                        [];
                                    rolePerms.forEach((code, hasAccess) {
                                      permList.add({
                                        'grant_type': hasAccess
                                            ? 'ALLOW'
                                            : 'DENY',
                                        'permission': code,
                                      });
                                    });
                                    await context
                                        .read<PermissionCubit>()
                                        .updateRolePermissions(
                                          roleName: role.roleNameValue,
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
