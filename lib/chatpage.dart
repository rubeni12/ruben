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

  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse("http://172.28.192.1/pray/get_messages.php"));
    if (response.statusCode == 200) {
      setState(() {
        messages = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Room")),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.message),
            title: Text(messages[index]['message']),
            subtitle: Text("From: ${messages[index]['username']}"),
          );
        },
      ),
    );
  }
}
