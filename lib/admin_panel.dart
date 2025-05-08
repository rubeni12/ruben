import 'dart:convert';
import 'dart:io'; // Import for File class
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseUrl =
    "http://192.168.254.78/BriphatMedia/ALL-PROJECTS/flutter_auth/pray";
const String _bookRoomEndpoint = '$_baseUrl/book_room.php';
const String _addRoomEndpoint = '$_baseUrl/add_room.php';
const String _getBookingsEndpoint = '$_baseUrl/get_bookings.php';
const String _deleteBookingEndpoint = '$_baseUrl/delete_booking.php';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<Map<String, dynamic>> _rooms = [];

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  // Function to fetch rooms from the PHP API
  Future<void> _fetchRooms() async {
    try {
      final response = await http.get(
        Uri.parse('http://your_server_address/get_rooms.php'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _rooms = data.cast<Map<String, dynamic>>();
        _isLoading = false;
        _errorMessage = null;
      } else {
        _isLoading = false;
        _errorMessage = 'Failed to fetch rooms: ${response.statusCode}';
      }
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'Error fetching rooms: $error';
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

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
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.teal)
                : _errorMessage != null
                ? Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                )
                : _rooms.isEmpty
                ? const Text(
                  'No rooms available.',
                  style: TextStyle(fontSize: 18),
                )
                : ListView.builder(
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          'Room ${room['room_number']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Type: ${room['room_type']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomListScreen(),
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
      ),
    );
  }
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late TextEditingController roomNumberController;
  late TextEditingController roomTypeController;
  late TextEditingController priceController;

  late TextEditingController roomImageController;

  late TextEditingController userEmailController;
  late TextEditingController roomNumberToBookController;
  late TextEditingController bookingDateController;
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _bookings = [];
  File? _image;
  //final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    roomNumberController = TextEditingController();
    roomTypeController = TextEditingController();
    priceController = TextEditingController();
    roomImageController = TextEditingController();
    userEmailController = TextEditingController();
    roomNumberToBookController = TextEditingController();
    bookingDateController = TextEditingController(
      text: DateTime.now().toString().split(' ')[0],
    );
    _getBookings();
  }

  @override
  void dispose() {
    roomNumberController.dispose();
    roomTypeController.dispose();
    priceController.dispose();
    roomImageController.dispose();
    userEmailController.dispose();
    roomNumberToBookController.dispose();
    bookingDateController.dispose();
    super.dispose();
  }

  Future<void> _bookRoom() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> bookingData = {
        'email': userEmailController.text,
        'room_number': roomNumberToBookController.text,
        'booking_date': bookingDateController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(_bookRoomEndpoint),
          body: bookingData,
        );

        if (response.statusCode == 200) {
          var resBody = jsonDecode(response.body);
          if (resBody['success'] == true) {
            _showDialog(context, 'Success', 'Room booked successfully!');

            setState(() {
              userEmailController.clear();
              roomNumberToBookController.clear();
              bookingDateController.text =
                  DateTime.now().toString().split(' ')[0];
            });
            _getBookings();
          } else {
            _showDialog(
              context,
              'Booking Failed',
              resBody['message'] ?? 'Failed to book room.',
            );
          }
        } else {
          _showDialog(
            context,
            'Server Error',
            'Failed to connect to the server. Please try again later.',
          );
          print('Server error: ${response.statusCode}');
        }
      } catch (e) {
        _showDialog(
          context,
          'Error',
          'An error occurred. Please check your connection.',
        );
        print('Error: $e');
      }
    }
  }

  Future<void> _addRoom() async {
    if (_formKey.currentState!.validate()) {
      var request = http.MultipartRequest('POST', Uri.parse(_addRoomEndpoint));
      request.fields['room_number'] = roomNumberController.text;
      request.fields['room_type'] = roomTypeController.text;
      request.fields['price'] = priceController.text;

      if (_image != null) {
        var stream = http.ByteStream(_image!.openRead());
        var length = await _image!.length();
        var multipartFile = http.MultipartFile(
          'room_image',
          stream,
          length,
          filename: _image!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          var resBody = await response.stream.bytesToString();
          var decodedRes = jsonDecode(resBody);
          if (decodedRes['success'] == true) {
            _showDialog(context, 'Success', 'Room added successfully!');

            setState(() {
              roomNumberController.clear();
              roomTypeController.clear();
              priceController.clear();
              roomImageController.clear();
              _image = null;
            });
          } else {
            _showDialog(
              context,
              'Failed to Add Room',
              decodedRes['message'] ?? 'Failed to add room.',
            );
          }
        } else {
          _showDialog(
            context,
            'Server Error',
            'Failed to connect to the server. Please try again later.',
          );
          print('Server error: ${response.statusCode}');
        }
      } catch (e) {
        _showDialog(
          context,
          'Error',
          'An error occurred. Please check your connection.',
        );
        print('Error: $e');
      }
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _getBookings() async {
    try {
      final response = await http.get(Uri.parse(_getBookingsEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data =
            json.decode(response.body)['bookings']; // Adjust
        setState(() {
          _bookings = List<Map<String, dynamic>>.from(data);
        });
      } else {
        _showDialog(
          context,
          "Error",
          "Failed to fetch bookings: ${response.statusCode}",
        );
      }
    } catch (e) {
      _showDialog(context, "Error", "Error fetching bookings: $e");
      print("Error fetching bookings: $e");
    }
  }

  Future<void> _deleteBooking(int bookingId) async {
    try {
      final response = await http.post(
        Uri.parse(_deleteBookingEndpoint),
        body: {'id': bookingId.toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          _showDialog(context, "Success", "Booking deleted successfully.");
          _getBookings();
        } else {
          _showDialog(
            context,
            "Error",
            data['message'] ?? "Failed to delete booking.",
          );
        }
      } else {
        _showDialog(
          context,
          "Error",
          "Failed to delete booking: ${response.statusCode}",
        );
      }
    } catch (e) {
      _showDialog(context, "Error", "Error deleting booking: $e");
      print("Error deleting booking: $e");
    }
  }

  // Function to pick image
  Future<void> getImage() async {
   // final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    //setState(() {
     // if (pickedFile != null) {
      //  _image = File(pickedFile.path);
      //} else {
      //  print('No image selected.');
      }
  //  });
 // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Add Room',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: roomNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Room Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter room number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: roomTypeController,
                decoration: InputDecoration(
                  labelText: 'Room Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter room type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid price format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Image Upload Section
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: roomImageController,
                      decoration: InputDecoration(
                        labelText: 'Room Image',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      enabled: false,
                      validator: (value) {
                        if (_image == null) {
                          return 'Please select an image';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: getImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Browse'),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              if (_image != null) ...[
                if (foundation.kIsWeb)
                  Image.network(Uri.file(_image!.path).toString(), height: 100)
                else
                  Image.file(_image!, height: 100),
                const SizedBox(height: 15),
              ],
              ElevatedButton(
                onPressed: _addRoom,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add Room', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Book Room',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: userEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'User Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter user email';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: roomNumberToBookController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Room Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter room number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: bookingDateController,
                decoration: InputDecoration(
                  labelText: 'Booking Date',
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter booking date';
                  }

                  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                    return 'Invalid date format (YYYY-MM-DD)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _bookRoom,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Book Room', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bookings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              if (_bookings.isEmpty)
                const Text('No bookings yet.', style: TextStyle(fontSize: 16))
              else
                Column(
                  children:
                      _bookings.map((booking) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email: ${booking['email']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Room: ${booking['room_number']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Date: ${booking['booking_date']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text(
                                              'Delete Booking',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this booking?',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.grey,
                                                ),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _deleteBooking(booking['id']);
                                                  Navigator.of(context).pop();
                                                },
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                ),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}
