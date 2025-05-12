import 'package:flutter/material.dart';

class DeleteRoomScreen extends StatefulWidget {
  const DeleteRoomScreen({super.key});

  @override
  State<DeleteRoomScreen> createState() => _DeleteRoomScreenState();
}

class _DeleteRoomScreenState extends State<DeleteRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNumberController = TextEditingController();

  Future<void> _deleteRoom() async {
    if (_formKey.currentState!.validate()) {
      final roomNumber = _roomNumberController.text;

      print('Deleting room with number: $roomNumber');
      // After successful deletion, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room deleted successfully!')),
      );
      _roomNumberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _roomNumberController,
                decoration: const InputDecoration(labelText: 'Room Number to Delete'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the room number to delete';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteRoom,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}