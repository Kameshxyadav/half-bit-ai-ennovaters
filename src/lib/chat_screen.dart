import 'package:flutter/material.dart';
import 'ai_logic.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AI ai = AI();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'user': text});
      messages.add({'ai': ai.respond(text)});
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('HALF BIT AI'),
        backgroundColor: Colors.red[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                if (msg.containsKey('user')) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['user']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['ai']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            color: Colors.red[900],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
