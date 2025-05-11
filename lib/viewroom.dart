import 'package:flutter/material.dart';

class ViewRoomScreen extends StatelessWidget {
  const ViewRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> rooms = [
      {
        'image': 'assets/images/house.jpg',
        'title': 'Single Room',
        'description': 'Comfortable single room with desk and fan.',
        'price': 'Tsh 5000 per night',
      },
      {
        'image': 'assets/images/image.jpg',
        'title': 'Double Room',
        'description': 'Spacious double room ideal for two people.',
        'price': 'Tsh 8000 per night',
      },
      {
        'image': 'assets/images/hostl.jpeg',
        'title': 'Deluxe Room',
        'description': 'Modern deluxe room with smart TV and AC.',
        'price': 'Tsh 12000 per night',
      },
      {
        'image': 'assets/images/image.jpg',
        'title': 'Executive Suite',
        'description': 'Executive suite with lounge and kitchenette.',
        'price': 'Tsh 20000 per night',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("View Rooms")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: rooms.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final room = rooms[index];
            return RoomCard(
              imageUrl: room['image']!,
              roomTitle: room['title']!,
              roomDescription: room['description']!,
              price: room['price']!,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoomDetailsScreen(roomName: room['title']!),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final String imageUrl;
  final String roomTitle;
  final String roomDescription;
  final String price;
  final VoidCallback onPress;

  const RoomCard({
    super.key,
    required this.imageUrl,
    required this.roomTitle,
    required this.roomDescription,
    required this.price,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              roomTitle,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              roomDescription,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              price,
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: onPress,
              child: const Text("BOOK NOW"),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomDetailsScreen extends StatelessWidget {
  final String roomName;

  const RoomDetailsScreen({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$roomName Details")),
      body: Center(
        child: Text('Details for $roomName'),
      ),
    );
  }
}
