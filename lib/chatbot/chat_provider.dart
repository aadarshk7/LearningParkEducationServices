import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_key.dart';

class ChatProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  late SharedPreferences _prefs;
  late GenerativeModel _model;

  ChatProvider() {
    _initSharedPreferences();
    _model = GenerativeModel(
        model: 'gemini-1.5-flash', apiKey: GeminiAPIKEY.api_key);
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadChatHistory();
  }

  List<Map<String, String>> get messages => _messages;

  void _loadChatHistory() {
    final history = _prefs.getStringList('chat_history');
    if (history != null) {
      _messages.addAll(history
          .map((msg) => jsonDecode(msg) as Map<String, String>)
          .toList());
      notifyListeners();
    }
  }

  void _saveMessageToSharedPreferences(Map<String, String> message) {
    _messages.add(message);
    final List<String> history =
        _messages.map((msg) => jsonEncode(msg)).toList();
    _prefs.setStringList('chat_history', history);
    notifyListeners();
  }

  void sendMessage(String message) {
    final newMessage = {'user': message};
    _saveMessageToSharedPreferences(newMessage);

    _model.generateContent([Content.text(message)]).then((response) {
      String? botResponseText = response.text;

      // Identify URLs and append "https://" if not present
      final urlPattern = RegExp(r'(https?:\/\/[^\s]+)|(www\.[^\s]+)');
      botResponseText = botResponseText?.replaceAllMapped(urlPattern, (match) {
        String url = match[0]!;
        if (!url.startsWith('http')) {
          url = 'https://' + url;
        }
        return url;
      });

      final botResponse = {'bot': botResponseText};
      _saveMessageToSharedPreferences(
          botResponse.map((key, value) => MapEntry(key, value ?? "")));
    }).catchError((error) {
      print('Error generating bot response: $error');
    });
  }
}
