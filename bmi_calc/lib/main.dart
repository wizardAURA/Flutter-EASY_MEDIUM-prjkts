import 'package:flutter/material.dart';
import 'input_pg.dart';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(

            color: Color(0xff0E7373),
          shadowColor: Color(0xef193c40),
          elevation: 50,
        ),
      ),

      home: InputPage(),
    );
  }
}

