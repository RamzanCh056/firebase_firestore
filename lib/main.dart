import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.red[900],
          colorScheme: ColorScheme.light(primary: Colors.red[900]!),
          appBarTheme: AppBarTheme(
            color: Colors.red[900],
          ),
          scaffoldBackgroundColor: const Color(0xFFfffafa),
          fontFamily: 'regular'),
      home: const SplashScreen(),
    );
  }
}
