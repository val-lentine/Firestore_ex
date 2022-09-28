import 'package:flutter/material.dart';
import 'package:real_ex/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First App',
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: LoginScreen(),
    );
  }
}
