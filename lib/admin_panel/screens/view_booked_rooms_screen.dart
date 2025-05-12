import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewBookedRoomsScreen extends StatefulWidget {
  const ViewBookedRoomsScreen({super.key});

  @override
  State<ViewBookedRoomsScreen> createState() => _ViewBookedRoomsScreenState();
}

class _ViewBookedRoomsScreenState extends State<ViewBookedRoomsScreen> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBookedRooms();
  }

  Future<void> _fetchBookedRooms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {

      final response = await http.get(Uri.parse('YOUR_PHP_BACKEND_URL/get_booked_rooms.php'));
      if (response.statusCode == 200) {
        setState(() {
          _bookings = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load bookings';
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
        title: const Text('Booked Rooms'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _bookings.isEmpty
          ? const Center(child: Text('No rooms booked yet.'))
          : ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          return ListTile(
            title: Text('Room: ${booking['room_number'] ?? 'N/A'}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${booking['user_id'] ?? 'N/A'}'),
                Text('Check-in: ${booking['check_in_date'] ?? 'N/A'}'),
                Text('Check-out: ${booking['check_out_date'] ?? 'N/A'}'),
                // Add more booking details as needed
              ],
            ),
          );
        },
      ),
    );
  }
}