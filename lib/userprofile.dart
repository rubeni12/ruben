import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Kuleta LoginPage kwa log out functionality

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

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'N/A';
      userEmail = prefs.getString('user_email') ?? 'N/A';
      userContact = prefs.getString('user_contact') ?? 'N/A';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Load user data on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                  prefs.remove('user_name');
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
