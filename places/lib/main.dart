import 'package:places/Tabs/Introduction.dart';
import 'package:places/Tabs/login.dart';
import 'package:places/Tabs/sign.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:places/Tabs/home_page.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}  // main

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: Introduction.tag,
      routes: {
        Introduction.tag: (context) => Introduction(),
        Home.tag: (context) => Home(""),
        login.tag: (context) => login(),
        sign.tag: (context) => sign()
      },  // routes
    );
  }  // build
}  // MyApp