import '../services/current_location_service.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/message_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/voice_wrapper.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.insert(0, Message(text: userText, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    final response = await ApiService.fetchChatbotResponse(userText);

    setState(() {
      _messages.insert(0, Message(text: response, isUser: false));
      _isLoading = false;
    });

    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentLocationService.setPage('chat');

    return VoiceWrapper(
      child: Scaffold(
        backgroundColor: Colors.black, // High-contrast black background
        appBar: AppBar(
          backgroundColor: Colors.yellow[700], // Bright yellow for contrast
          title: const Text(
            "DoubtBOT",
            style: TextStyle(
              fontSize: 30, // Larger text for accessibility
              fontWeight: FontWeight.bold,
              color: Colors.black, // High contrast with app bar background
              letterSpacing: 1.2, // Premium typography
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == 0) {
                    return const TypingIndicator();
                  }
                  final msgIndex = _isLoading ? index - 1 : index;
                  return ChatBubble(message: _messages[msgIndex]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12), // Increased padding
              color: Colors.black, // Consistent with background
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        fontSize: 22, // Larger text for accessibility
                        color: Colors.yellow[700], // High contrast
                      ),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(
                          color: Colors.yellow[700]!
                              .withOpacity(0.6), // Muted hint
                          fontSize: 20,
                        ),
                        filled: true,
                        fillColor: Colors.black87, // Dark input background
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(16), // Rounded edges
                          borderSide: BorderSide(
                            color: Colors.yellow[700]!, // Yellow border
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.yellow[700]!, // Yellow border
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors
                                .yellow[300]!, // Brighter yellow when focused
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Increased spacing
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Semantics(
                      label: "Send message",
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: Icon(
                          Icons.send,
                          size: 36, // Larger icon for accessibility
                          color: Colors.yellow[700], // High contrast
                        ),
                        padding:
                            const EdgeInsets.all(12), // Larger touch target
                        splashRadius: 28, // Visual feedback for interaction
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
