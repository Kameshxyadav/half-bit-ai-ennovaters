import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HALF BIT AI',
      theme: ThemeData(
        primaryColor: Colors.red[900],
      ),
      home: const ChatScreen(),
    );
  }
}
