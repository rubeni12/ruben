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
  bool _isLoading = false; // To track loading state
  bool _currentPasswordVisible = false; // Toggle visibility for current password
  bool _newPasswordVisible = false; // Toggle visibility for new password

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty || newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields'))
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loader
    });

    final url = Uri.parse("http://192.168.26.215/RENTING_ROOM/change_password.php"); // Change to your actual API URL
    try {
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message']))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message']))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change password'))
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current Password TextField
          TextField(
            controller: currentPasswordController,
            obscureText: !_currentPasswordVisible, // Toggle visibility
            decoration: InputDecoration(
              labelText: 'Current Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _currentPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _currentPasswordVisible = !_currentPasswordVisible;
                  });
                },
              ),
            ),
          ),
          // New Password TextField
          TextField(
            controller: newPasswordController,
            obscureText: !_newPasswordVisible, // Toggle visibility
            decoration: InputDecoration(
              labelText: 'New Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _newPasswordVisible = !_newPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        _isLoading
            ? const CircularProgressIndicator() // Show loader while loading
            : ElevatedButton(
          onPressed: changePassword,
          child: const Text("Change"),
        ),
      ],
    );
  }
}
