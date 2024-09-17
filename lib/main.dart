import 'package:bloc_notes/historique.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {

  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  const Historique()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.blueAccent.withOpacity(0.5),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/bloc_notes_transparent.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
