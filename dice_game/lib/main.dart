import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int ldicenumber = Random().nextInt(6)+1;
  int rdicenumber = 1;
  void diceroll(){
    setState(() {
      ldicenumber = Random().nextInt(6)+1;
      rdicenumber = Random().nextInt(6)+1;
    });
  }
  @override

  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(title: const Center(child: Text('DICE',
          style: TextStyle(
            fontFamily: 'pixel',
            fontSize: 30,
          ),
        ),
        ),
        ),
        body:  Center(
          child: Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton( onPressed: (){
                diceroll();
                }, child: Image.asset('images/dice$ldicenumber.png')),
              ),

              ),

              Expanded(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(onPressed: (){
                  diceroll();
                }, child: Image.asset('images/dice$rdicenumber.png')),
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}

