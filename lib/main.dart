import 'package:flutter/material.dart';
import 'package:weather_application/screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheater',
        theme: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: const Color(0xFFD3CCE3),
            secondary: const Color(0xFF3f2b96)
          ),
        ),
      home: Home()
    );
  }
}