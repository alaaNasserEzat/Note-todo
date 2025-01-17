import 'package:flutter/material.dart';
import 'package:noteapp/classes/sqel.dart';
import 'package:noteapp/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  sqelhelper().getDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: hompage(),
    );
    
     }}