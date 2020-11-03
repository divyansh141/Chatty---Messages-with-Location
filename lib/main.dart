import 'package:Chatty/chatPage.dart';
import 'package:Chatty/inbox.dart';
import 'package:Chatty/loginPage.dart';
import 'package:Chatty/regPage.dart';
import 'package:Chatty/searchPage.dart';
import 'package:Chatty/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        'loginPage': (context) => LoginPage(),
        'regPage': (context) => RegPage(),
        'splash': (context) => Splash(),
        'chatPage': (context) => ChatPage(),
        'inbox': (context) => Inbox(),
        'searchPage': (context) => SearchPage(),
      },
    );
  }
}
