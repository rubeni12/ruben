import 'package:flutter/material.dart';
import 'package:ruben/roombooking.dart';
import 'package:ruben/setting.dart';
import 'package:ruben/userprofile.dart';
import 'package:ruben/viewroom.dart';
import 'package:ruben/welcome.dart';
import 'admin_panel.dart';
import 'change_password_dialog.dart';
import 'chatpage.dart';
import 'main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NIT HOSTEL RENTING APPLICATION")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'USER MENU',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),);

              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),);
              },
            ),
            // New "View Room" item before "Room Booking"
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Room'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the View Room screen (replace with your actual screen)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRoomScreen()), // Update with your actual screen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.hotel),
              title: const Text('Room Booking'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRoomScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangePasswordDialog();
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            Image.asset('assets/images/image.jpg'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background Image
                  Image.asset(
                    'assets/images/house.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 600, // Adjust height as needed
                  ),

                  // Centered Text
                  Text(
                    'GET AFFORDABLE ROOMS FOR RENT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreenAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
