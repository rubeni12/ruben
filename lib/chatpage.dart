import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> messages = [];
  TextEditingController messageController = TextEditingController();
  String username = "user"; // Badilisha jina kama unataka

  Future<void> fetchMessages() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.26.215/RENTING_ROOM/chathandel.php"), // Badilisha kama inahitajika
      );

      if (response.statusCode == 200) {
        setState(() {
          messages = json.decode(response.body).reversed.toList(); // newest last
        });
      } else {
        _showError("Imeshindikana kupokea ujumbe");
      }
    } catch (e) {
      _showError("Hitilafu ya mtandao: $e");
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse("http://192.168.64.44/RENTING_ROOM"),
        headers: {
          'Content-Type': 'application/json', // Hapa tunatuma JSON
        },
        body: json.encode({
          "username": username,
          "message": messageController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        messageController.clear();
        fetchMessages();
      } else {
        _showError("Imeshindikana kutuma ujumbe");
      }
    } catch (e) {
      _showError("Hitilafu ya kutuma ujumbe: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CHATTING ROOM")),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchMessages,
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  messages[index]['message'],
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "— ${messages[index]['username']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Andika ujumbe hapa...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
