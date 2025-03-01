import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];
  List<ChatUser> typingUsers = [];

  ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'User',
    profileImage: 'https://avatars.githubusercontent.com/u/101011121?v=4',
  );
  ChatUser vortexAIUser = ChatUser(
    id: '1',
    firstName: 'VortexAI', // Changed from "Gemini" to "VortexAI"
    profileImage:
        'https://ibb.co.com/TBZ7yYnw',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUI(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      
      centerTitle: true,
      title: const Text(
        'VortexAI',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 16, 24, 48), // Deep space navy
              Color.fromARGB(255, 72, 175, 240), // Electric sky blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F1A20), // Arctic night blue
            Color(0xFF4B79A1), // Frostbite blue
            Color(0xFFE0FFFF), // Ice glow
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DashChat(
        typingUsers: typingUsers,
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
        messageOptions: MessageOptions(
          currentUserContainerColor: Color(0xFFF5F5F5),
          containerColor: Color(0xFFD4AF37),
          textColor: Colors.black87,
          currentUserTextColor: Colors.black87,
          messagePadding: const EdgeInsets.all(12),
          borderRadius: 16,
          showTime: true,
          timeTextColor: Colors.black54,
        ),
        inputOptions: InputOptions(
          cursorStyle: const CursorStyle(color: Colors.black),
          inputDecoration: InputDecoration(
            hintText: 'Type a message...',
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          inputTextStyle: const TextStyle(color: Colors.black87),
          trailing: [
            IconButton(
              icon: const Icon(Icons.image, color: Colors.black87),
              onPressed: _sendMediaMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
      typingUsers = [vortexAIUser]; // Changed to show "VortexAI is typing"
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        print("Reading image from: ${chatMessage.medias!.first.url}");
        images = [await File(chatMessage.medias!.first.url).readAsBytes()];
        print("Image bytes length: ${images[0].length}");
      }

      String fullPrompt = _buildFullPrompt(question);
      print("Full Prompt: $fullPrompt");

      Candidates? response;
      if (images != null && images.isNotEmpty) {
        print("Sending textAndImage request...");
        response = await gemini.textAndImage(text: fullPrompt, images: images);
      } else {
        print("Sending text request...");
        response = await gemini.text(fullPrompt);
      }

      print("Full Response: $response");
      print("Content: ${response?.content}");
      print("Parts: ${response?.content?.parts}");
      if (response?.content?.parts != null && response!.content!.parts!.isNotEmpty) {
        print("First Part: ${response.content!.parts!.first}");
      }

      if (response != null && response.content != null) {
        String answer = _extractAnswerFromResponse(response);
        if (answer.isNotEmpty) {
          ChatMessage vortexAIResponse = ChatMessage(
            user: vortexAIUser, // Responses from "VortexAI"
            createdAt: DateTime.now(),
            text: answer,
          );
          setState(() {
            messages = [vortexAIResponse, ...messages];
            typingUsers = [];
          });
        } else {
          _handleNoResponse();
        }
      } else {
        _handleNoResponse();
      }
    } catch (e) {
      print("Error Details: $e");
      _handleError(e.toString());
    }
  }

  String _buildFullPrompt(String currentMessage) {
    return currentMessage; // Simplified prompt
  }

  String _extractAnswerFromResponse(Candidates response) {
    if (response.content!.parts != null && response.content!.parts!.isNotEmpty) {
      dynamic firstPart = response.content!.parts!.first;
      return firstPart.text ?? firstPart.value ?? firstPart.toString();
    }
    return response.content.toString();
  }

  void _handleNoResponse() {
    setState(() {
      messages = [
        ChatMessage(
          user: vortexAIUser, // Changed to "VortexAI"
          createdAt: DateTime.now(),
          text: "Sorry, I couldn't generate a response.",
        ),
        ...messages
      ];
      typingUsers = [];
    });
  }

  void _handleError(String errorDetails) {
    String userMessage;
    if (errorDetails.contains("400")) {
      userMessage = "Oops, something went wrong with my request. Try again!";
    } else if (errorDetails.contains("Failed host lookup")) {
      userMessage = "Network issue. Please check your connection.";
    } else {
      userMessage = "An unexpected error occurred. Please try again.";
    }

    setState(() {
      messages = [
        ChatMessage(
          user: vortexAIUser, // Changed to "VortexAI"
          createdAt: DateTime.now(),
          text: userMessage,
        ),
        ...messages
      ];
      typingUsers = [];
    });
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      String? userInput = await _showInputDialog(context);
      if (userInput != null && userInput.isNotEmpty) {
        ChatMessage message = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: userInput,
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image),
          ],
        );
        _sendMessage(message);
      }
    }
  }

  Future<String?> _showInputDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Enter Your Message', style: TextStyle(color: Colors.black87)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: "Ask something about this image...",
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Send', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}