enum Emotion { positive, neutral, negative }

Emotion detectEmotion(String text) {
  final lower = text.toLowerCase();

  if ([
    "happy",
    "fine",
    "good",
    "great",
    "awesome",
    "amazing",
    "well",
    "fantastic",
    "excited",
    "love"
  ].any((w) => lower.contains(w))) return Emotion.positive;

  if ([
    "sad",
    "tired",
    "bad",
    "upset",
    "angry",
    "frustrated",
    "down",
    "worried",
    "hate"
  ].any((w) => lower.contains(w))) return Emotion.negative;

  return Emotion.neutral;
}

class ConversationFlow {
  static String greetingFlow(String userText) {
    final emotion = detectEmotion(userText);
    final lower = userText.toLowerCase();

    if (lower.contains("hi") || lower.contains("hello"))
      return "Hello! How are you today?";
    if (lower.contains("how are you"))
      return "I'm good, thanks! How about you?";

    switch (emotion) {
      case Emotion.positive:
        return "Glad to hear that! What have you been up to?";
      case Emotion.negative:
        return "Oh no, I'm sorry to hear that. Want to talk about it?";
      default:
        return "";
    }
  }

  static String smallTalkFlow(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains("bye") || lower.contains("goodbye"))
      return "See you later!";
    if (lower.contains("thanks")) return "You're welcome!";
    if (lower.contains("weather"))
      return "I don't know exactly, but I hope it's nice outside!";
    return "";
  }
}
