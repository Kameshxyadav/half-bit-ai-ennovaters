import 'dart:math';
import 'conversation_flow.dart';

class AI {
  final Random _random = Random();

  String respond(String input) {
    final convReply = ConversationFlow.greetingFlow(input);
    if (convReply.isNotEmpty) return convReply;

    final smallReply = ConversationFlow.smallTalkFlow(input);
    if (smallReply.isNotEmpty) return smallReply;

    // fallback defaults
    final defaults = [
      "Tell me more...",
      "Interesting!",
      "Oh really?",
    ];
    return defaults[_random.nextInt(defaults.length)];
  }
}
