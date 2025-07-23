class ChatResponse {
  final String message;

  ChatResponse({required this.message});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    // Pick 'message' or 'output' dynamically
    String text = '';
    if (json.containsKey('message')) {
      text = json['message'] ?? '';
    } else if (json.containsKey('output')) {
      text = json['output'] ?? '';
    } else if (json.containsKey('answer')) {
      text = json['answer'] ?? '';
    } else {
      text = '🤖 No response from AI.';
    }

    return ChatResponse(message: text);
  }
}
