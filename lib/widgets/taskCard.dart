import 'package:flutter/material.dart';

class taskCard extends StatelessWidget {
  const taskCard({super.key,  required this.color,
    required this.headerText,
    required this.descriptionText,
    required this.scheduledDate,});
  final Color color;
  final String headerText;
  final String descriptionText;
  final String scheduledDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
    padding: const EdgeInsets.symmetric(vertical: 20.0).copyWith(
    left: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(headerText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            Padding(
              padding: const EdgeInsets.only(right: 20,bottom: 25),
              child: Text(descriptionText,
              style: TextStyle(fontSize: 14),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,)
            ),
            Text(
              scheduledDate,
              style: const TextStyle(fontSize: 17),
            ),
          ],
          
        ),
      ),
    );
  }
}

