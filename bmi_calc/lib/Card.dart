import 'package:flutter/material.dart';

class Carde extends StatelessWidget {
  Carde({ required this.colour, required this.childcar, required this.onpress});

  final Color colour;
  final Widget childcar;
  final Function() onpress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        width: 170,
        child: childcar,
      ),
    );
  }
}