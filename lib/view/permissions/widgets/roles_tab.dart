import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/model/UserModel/Permission_model.dart';
import 'package:ocean_sys/model/permission_list_model.dart';
import 'package:ocean_sys/model/role_model.dart';
import '../cubit/permission_cubit.dart';
import '../cubit/permission_state.dart';

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
