import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RAGChatScreen extends StatefulWidget {
  const RAGChatScreen({super.key});

  @override
  State<RAGChatScreen> createState() => _RAGChatScreenState();
}

class _RAGChatScreenState extends State<RAGChatScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: 'user');
  final _bot = const types.User(
    id: 'bot',
    firstName: 'SafeBot',
    imageUrl: 'https://randomuser.me/api/portraits/men/31.jpg',
  );

  late Box _chatBox;

  // Connectivity
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _loadMessagesFromCache();
    _initConnectivity(); // initial status
    _monitorConnectivity(); // ongoing updates
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /// Initial connectivity check
  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (_) {
      // If check fails, leave state as-is; you could mark offline conservatively
    }
  }

  /// Start listening to connectivity changes
  void _monitorConnectivity() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  /// Handle connectivity updates
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Consider "offline" when list contains ConnectivityResult.none OR list empty
    final hasConnection =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    setState(() => _isOffline = !hasConnection);
  }

  /// Load cached messages from Hive
  Future<void> _loadMessagesFromCache() async {
    _chatBox = Hive.box('chat_cache');
    final cachedData = _chatBox.get('messages', defaultValue: []);
    if (cachedData.isNotEmpty) {
      setState(() {
        _messages = (cachedData as List)
            .map((e) => types.TextMessage.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList();
      });
    }
  }

  /// Save messages to Hive
  void _saveMessagesToCache() {
    final data =
        _messages.map((msg) => (msg as types.TextMessage).toJson()).toList();
    _chatBox.put('messages', data);
  }

  /// Send pressed
  Future<void> _handleSendPressed(types.PartialText message) async {
    final userMsg = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, userMsg);
    });
    _saveMessagesToCache();

    if (_isOffline) {
      final offlineMsg = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: "⚠️ You're offline. Message saved locally.",
      );
      setState(() {
        _messages.insert(0, offlineMsg);
      });
      _saveMessagesToCache();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://himanshuthakor.app.n8n.cloud/webhook-test/425e3445-a735-44ae-95b0-500aa8672386'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': message.text, 'sessionId': _user.id}),
      );

      print('Raw Response: ${response.body}');

      String replyText;
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          replyText = data['output'] ?? data['message'] ?? '🤖 No response.';
        } catch (_) {
          replyText = '🤖 Failed to parse response.';
        }
      } else {
        replyText = '❌ Server error: ${response.statusCode}';
      }

      final botMsg = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: replyText,
      );

      setState(() {
        _messages.insert(0, botMsg);
      });
      _saveMessagesToCache();
    } catch (e) {
      final errorMsg = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: '⚠️ Error: $e',
      );

      setState(() {
        _messages.insert(0, errorMsg);
      });
      _saveMessagesToCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📄 RAG Chat Assistant')),
      body: Column(
        children: [
          if (_isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.amber,
              child: const Text(
                "⚠️ You are offline – using cached messages",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _user,
              showUserAvatars: true,
              showUserNames: true,
              theme: const DefaultChatTheme(
                inputBackgroundColor: Colors.white,
                primaryColor: Colors.blue,
                secondaryColor: Color(0xFFEFEFEF),
                inputTextColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
