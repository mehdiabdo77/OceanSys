import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocean_sys/constans/decrations.dart';
import 'package:ocean_sys/constans/text_style.dart';
import 'package:ocean_sys/data/repository/user_repository.dart';
import 'package:ocean_sys/model/UserModel/user_model.dart';

class DialogSearchUser extends StatefulWidget {
  const DialogSearchUser({super.key});

  @override
  State<DialogSearchUser> createState() => _DialogSearchUserState();
}

class _DialogSearchUserState extends State<DialogSearchUser> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userRepository = context.read<UserRepository>();
    final users = await userRepository.getAllUsers();
    if (mounted) {
      setState(() {
        // فقط کاربران فعال را نمایش می‌دهیم
        _allUsers = users.where((u) => u.isActive == true).toList();
        _filteredUsers = _allUsers;
        _isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final fullName = "${user.firstName ?? ''} ${user.lastName ?? ''}"
            .toLowerCase();
        final username = (user.user ?? '').toLowerCase();
        return fullName.contains(query.toLowerCase()) ||
            username.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("جستجوی کاربر", style: MyTextStyle.textBlack16),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: MyDecorations.inputDecoration.copyWith(
                hintText: "نام یا نام کاربری...",
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _filterUsers,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _filteredUsers.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return ListTile(
                      title: Text(
                        "${user.firstName ?? ''} ${user.lastName ?? ''}",
                        style: MyTextStyle.textBlak12.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "نام کاربری: ${user.user ?? ''}",
                        style: MyTextStyle.caption,
                      ),
                      trailing: Text(
                        "ID: ${user.id}",
                        style: MyTextStyle.caption,
                      ),
                      onTap: () => Navigator.pop(context, user),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("انصراف", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
