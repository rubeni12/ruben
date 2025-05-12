import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  AddRoomScreenState createState() => AddRoomScreenState();
}

class AddRoomScreenState extends State<AddRoomScreen> {
  final _roomNameController = TextEditingController();
  final _roomPriceController = TextEditingController();
  final _roomDescriptionController = TextEditingController();
  final _roomLocationController = TextEditingController();
  File? _image;

  final picker = ImagePicker();
  bool isLoading = false;

  // Pick image from gallery
  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  // Send room data to the server
  Future<void> addRoom() async {
    if (_image == null ||
        _roomNameController.text.isEmpty ||
        _roomPriceController.text.isEmpty ||
        _roomDescriptionController.text.isEmpty ||
        _roomLocationController.text.isEmpty) {
      // Check if all fields are filled and an image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and select an image.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest('POST', Uri.parse("http://192.168.65.194/RENTING_ROOM/addroom.php"));
    request.fields['room_name'] = _roomNameController.text;
    request.fields['room_price'] = _roomPriceController.text;
    request.fields['room_description'] = _roomDescriptionController.text;
    request.fields['room_location'] = _roomLocationController.text;

    // Add image file
    var imageFile = await http.MultipartFile.fromPath('room_image', _image!.path);
    request.files.add(imageFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final result = jsonDecode(respStr);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );

      if (result['success']) {
        Navigator.pop(context); // Go back after successful submission
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add room. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Room'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Full-Screen Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/house.jpg'), // Update with your own image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Overlay to make text readable
          Positioned.fill(
            child: Container(
              color: Colors.blueGrey.withOpacity(0.5),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize vertical space
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Room Name Input
                  TextField(
                    controller: _roomNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Room Name',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Room Price Input
                  TextField(
                    controller: _roomPriceController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Room Price',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Room Description Input
                  TextField(
                    controller: _roomDescriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Room Description',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Room Location Input
                  TextField(
                    controller: _roomLocationController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Room Location',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Image preview and button to pick image
                  _image != null
                      ? Image.file(_image!, width: 150, height: 150, fit: BoxFit.cover)
                      : const Text('No image selected', style: TextStyle(color: Colors.white)),
                  ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Pick Image'),
                  ),

                  const SizedBox(height: 20),

                  // Submit Button with loading state
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: addRoom,
                    child: const Text('Submit Room'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
