import 'package:flutter/material.dart';
import 'package:provi/home.dart';
import 'package:provi/providr.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> Numbers())
      ],
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}
