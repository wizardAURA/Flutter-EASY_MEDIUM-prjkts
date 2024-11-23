import 'package:flutter/material.dart';
import 'style.dart';


class crdetail extends StatelessWidget {
  crdetail( { required this.label, required this.icon});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
          size: 80,),
        const SizedBox(height: 10.0),
        Text(label,
          style:kstyletext)
      ],
    );
  }
}