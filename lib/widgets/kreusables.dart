import 'package:flutter/material.dart';

class kTextformfield extends StatelessWidget {
  const kTextformfield( this.controller,  this.hinttext, {this.maxLines = 1});
  final TextEditingController controller;
  final String hinttext;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: controller,
      decoration:  InputDecoration(
        hintText: hinttext,
      ),
      maxLines: maxLines,
    );
  }
}
class kbtns extends StatelessWidget {
  const kbtns( this.child,  this.onpressed, this.txtcolour);
  final Widget child;
  final VoidCallback onpressed;
  final Color txtcolour;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      child: child,
    );
  }
}
