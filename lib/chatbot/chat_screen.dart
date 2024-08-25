import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_provider.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Any Doubts? Ask Me!'),
        backgroundColor:
            Colors.teal, // Changed to teal for consistency with QuotesPage
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                final isUser = message.containsKey('user');
                final text = isUser ? message['user'] : message['bot'];
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.all(16), // Increased padding for better UI
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.teal[200]
                          : Colors.teal[50], // Updated colors
                      borderRadius:
                          BorderRadius.circular(12), // Slightly rounded corners
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    child: Text(
                      text!,
                      style: TextStyle(
                        color: isUser
                            ? Colors.teal[900]
                            : Colors.teal[800], // Text color based on user
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.teal, // Icon color for consistency
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      chatProvider.sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
