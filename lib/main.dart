import 'package:chat_application/chat_screen.dart';
import 'package:chat_application/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: SafeArea(
        child: _auth.currentUser == null ? AuthScreen() : HomeScreen(),
      ),
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        AuthScreen.routeName: (_) => AuthScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
