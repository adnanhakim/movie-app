import 'package:MovieApp/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
          fontFamily: 'Proxima',
          primaryColor: Colors.blue,
          primaryColorDark: Colors.blue[900],
          scaffoldBackgroundColor: Color(0xF0F5F8FF)),
      home: HomeScreen(),
    );
  }
}