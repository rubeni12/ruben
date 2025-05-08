import 'dart:convert'; // Import the convert package
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package

class RoomListScreen extends StatelessWidget {
  // List of static room data
  final List<Map<String, dynamic>> _rooms = [
    {
      'name': 'Deluxe Room',
      'price': 120.0,
      'description': '2 Beds · Free Wi-Fi · AC',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Deluxe+Room',
      'location': 'City Center',
    },
    {
      'name': 'Standard Room',
      'price': 80.0,
      'description': '1 Bed · Garden View · Wi-Fi',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Standard+Room',
      'location': 'Suburban',
    },
    {
      'name': 'Suite Room',
      'price': 200.0,
      'description': '3 Beds · Sea View · Premium Services',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Suite+Room',
      'location': 'Beachfront',
    },
    {
      'name': 'Budget Room',
      'price': 50.0,
      'description': '1 Bed · Basic Amenities',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Budget+Room',
      'location': 'Downtown',
    },
    {
      'name': 'Family Room',
      'price': 150.0,
      'description': '2 Beds · Sofa Bed · City View',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Family+Room',
      'location': 'Residential Area',
    },
    {
      'name': 'Luxury Suite',
      'price': 300.0,
      'description': 'King Bed · Private Balcony · Spa Access',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Luxury+Suite',
      'location': 'Uptown',
    },
    {
      'name': 'Single Room',
      'price': 60.0,
      'description': '1 Bed · Quiet Area',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Single+Room',
      'location': 'Countryside',
    },
    {
      'name': 'Honeymoon Suite',
      'price': 250.0,
      'description': 'King Bed · Romantic Decor · Champagne',
      'imageUrl': 'https://via.placeholder.com/300x200?text=Honeymoon+Suite',
      'location': 'Seaside',
    },
  ];

  RoomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Rooms',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(room['imageUrl'], fit: BoxFit.cover),
              ),
              title: Text(
                room['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room['description']),
                  Text('Location: ${room['location']}'),
                  Text(
                    '\$${room['price']}/night',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Navigate to the booking form, passing the room details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingFormScreen(room: room),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Book Now'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookingFormScreen extends StatefulWidget {
  final Map<String, dynamic> room;

  const BookingFormScreen({super.key, required this.room});

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  // Controllers for the form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bookingDateController = TextEditingController();
  // Loading state
  bool _isLoading = false;
  // Error message
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    //_bookingDateController.text = DateFormat(
   //   'yyyy-MM-dd',
   // ).format(DateTime.now());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _bookingDateController.dispose();
    super.dispose();
  }

  // Function to handle the booking process
  Future<void> _bookRoom() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Format the booking date
        //final formattedDate = DateFormat(
         // 'yyyy-MM-dd',
        //).format(DateTime.parse(_bookingDateController.text));
        // Prepare the request body.  Include the room data.
        final Map<String, String> body = {
          'email': _emailController.text.trim(),
          'room_name': widget.room['name'].toString(),
          //'booking_date': //formattedDate,
          'room_price': widget.room['price'].toString(),
          'room_description':
              widget.room['description'].toString(), // Include description
          'room_location':
              widget.room['location'].toString(), // Include location
          'room_image_url':
              widget.room['imageUrl'].toString(), // Include image URL
        };

        // Replace 'http://your_server_address/book_room.php' with your actual server endpoint.
        final response = await http.post(
          Uri.parse(
            'http://192.168.254.78/BriphatMedia/ALL-PROJECTS/flutter_auth/pray/book_room.php',
          ),
          body: body,
        );

        if (response.statusCode == 200) {
          // Parse the JSON response
          final Map<String, dynamic> data = json.decode(response.body);
          if (data['success'] == true) {
            // Show a success message and navigate back to the room list
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Room booked successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            // Show the error message from the API
            _errorMessage = data['message'];
          }
        } else {
          // Handle HTTP errors
          _errorMessage = 'Failed to book room: ${response.statusCode}';
        }
      } catch (error) {
        // Handle network errors or other exceptions
        _errorMessage = 'Error booking room: $error';
      } finally {
        setState(() {
          _isLoading = false;
        });
        if (_errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Room', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Room ${widget.room['name']}', // Display Room Name
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Booking Date Field
                TextFormField(
                  controller: _bookingDateController,
                  decoration: const InputDecoration(
                    labelText: 'Booking Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'YYYY-MM-DD',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter booking date';
                    }
                    // Basic date format validation
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return 'Invalid date format (YYYY-MM-DD)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Book Room Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _bookRoom,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(
                            color: Colors.white,
                          ) // Show loading indicator
                          : const Text(
                            'Book Now',
                            style: TextStyle(fontSize: 18),
                          ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
