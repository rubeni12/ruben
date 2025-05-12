import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
import 'login.dart'; // Import LoginPage for log out functionality (adjust path as needed)
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for JSON decoding

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Variables for storing user data
  String userName = '';
  String userEmail = '';
  String userContact = '';
  String userId = ''; // To store the user ID from SharedPreferences
  bool _isLoading = true; // To manage loading state
  String _errorMessage = ''; // To store error messages

  // Load user data from API
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true; // Set loading state to true
      _errorMessage = ''; // Clear any previous error messages
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the user ID from SharedPreferences (assuming it was saved during login)
    userId = prefs.getString('user_id') ?? '';

    if (userId.isEmpty) {
      setState(() {
        _errorMessage = 'User ID not found. Please log in again.';
        _isLoading = false;
      });
      // Optionally, navigate back to login if user ID is missing
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }


    // For debugging

    try {
      final response = await http.get(Uri.parse('${Api.get_user_profile}?user_id=$userId'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final Map<String, dynamic> userData = json.decode(response.body);

        setState(() {
          userName = userData['name'] ?? 'N/A';
          userEmail = userData['email'] ?? 'N/A';
          userContact = userData['contact'] ?? 'N/A';
          _isLoading = false; // Data loaded, set loading state to false
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'User not found in the database. Please check user_id or database entries.';
          _isLoading = false;
        });
        print('User not found: ${response.body}');
      }
      else {
        // If the server did not return a 200 OK response,
        // throw an exception or show an error message.
        setState(() {
          _errorMessage = 'Failed to load user data. Status code: ${response.statusCode}. Response: ${response.body}';
          _isLoading = false;
        });
        print('Failed to load user data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Catch any network errors or other exceptions
      setState(() {
        _errorMessage = 'An error occurred: $e. Check network connection or server URL.';
        _isLoading = false;
      });
      print('Error during API call: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator
            : _errorMessage.isNotEmpty
            ? Center( // Show error message
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadUserData, // Retry button
                child: const Text('Retry'),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: $userName',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $userEmail',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Contact: $userContact',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // On button press, log out user and navigate back to login page
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('user_id');
                  prefs.remove('user_name'); // Remove cached data if any
                  prefs.remove('user_email');
                  prefs.remove('user_contact');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                });
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}