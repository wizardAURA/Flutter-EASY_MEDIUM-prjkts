import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/Taskscreen.dart';
import 'package:todolist/widgets/taskData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=> taskData(),
      child: MaterialApp(
        home: Tasksscreen(),
      ),
    );
  }
}
