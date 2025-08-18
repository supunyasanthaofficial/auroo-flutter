import 'package:flutter/material.dart';

class ChatSupport extends StatefulWidget {
  const ChatSupport({super.key});

  @override
  State<ChatSupport> createState() => _ChatSupportState();
}

class _ChatSupportState extends State<ChatSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Support')),
      body: const Center(child: Text('This is the Chat Support page')),
    );
  }
}
