import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final userId = "1"; // Change this to actual logged-in user ID

  Future<void> changePassword() async {
    final url = Uri.parse("http://172.28.192.1/pray/change_password.php");
    final response = await http.post(
      url,
      body: {
        'user_id': userId,
        'current_password': currentPasswordController.text,
        'new_password': newPasswordController.text,
      },
    );

    final data = json.decode(response.body);
    if (data['success']) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Current Password'),
          ),
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'New Password'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(onPressed: changePassword, child: const Text("Change")),
      ],
    );
  }
}
