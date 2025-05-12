import 'package:flutter/material.dart';
import 'package:ruben/admin_panel/screens/add_room_screen.dart';
import 'package:ruben/admin_panel/screens/delete_room_screen.dart';
import 'package:ruben/admin_panel/screens/view_booked_rooms_screen.dart';
import 'package:ruben/admin_panel/screens/view_user_registered.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Widget _currentScreen = const Center(
    child: Text('Welcome to the Admin Dashboard!', style: TextStyle(fontSize: 18)),
  );
  String _currentTitle = 'Admin Dashboard';

  void _navigateToScreen(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = title;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Panel Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_business),
              title: const Text('Add Room'),
              onTap: () {
                _navigateToScreen(const AddRoomScreen(), 'Add Room');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete Room'),
              onTap: () {
                _navigateToScreen(const DeleteRoomScreen(), 'Delete Room');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('View Registered Users'),
              onTap: () {
                _navigateToScreen(
                    const ViewRegisteredUsersScreen(), 'Registered Users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_added),
              title: const Text('View Booked Rooms'),
              onTap: () {
                _navigateToScreen(
                    const ViewBookedRoomsScreen(), 'Booked Rooms');
              },
            ),
          ],
        ),
      ),
      body: _currentScreen,
    );
  }
}