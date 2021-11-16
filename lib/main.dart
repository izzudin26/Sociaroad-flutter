import 'package:flutter/material.dart';
import 'package:society_road/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:society_road/navigation.dart';
import 'package:society_road/registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Society Road',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Registration(),
        '/navigation': (context) => NavigationApp()
      },
    );
  }
}
