import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewRegisteredUsersScreen extends StatefulWidget {
  const ViewRegisteredUsersScreen({super.key});

  @override
  State<ViewRegisteredUsersScreen> createState() => _ViewRegisteredUsersScreenState();
}

class _ViewRegisteredUsersScreenState extends State<ViewRegisteredUsersScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRegisteredUsers();
  }

  Future<void> _fetchRegisteredUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {

      final response = await http.get(Uri.parse('YOUR_PHP_BACKEND_URL/get_registered_users.php'));
      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load users';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Users'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _users.isEmpty
          ? const Center(child: Text('No registered users yet.'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['username'] ?? 'N/A'),
            subtitle: Text(user['email'] ?? 'N/A'),
            // Add more user details as needed
          );
        },
      ),
    );
  }
}