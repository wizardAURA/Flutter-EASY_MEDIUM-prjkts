import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';

import 'package:intl/intl.dart';

Color strengthenColor(Color color, double factor) {
  int r = (color.red * factor).clamp(0, 255).toInt();
  int g = (color.green * factor).clamp(0, 255).toInt();
  int b = (color.blue * factor).clamp(0, 255).toInt();
  return Color.fromARGB(color.alpha, r, g, b);
}


String dateFormatter(Timestamp? ts){
  if (ts == null) {
    return 'unknown Date';
  }
  return DateFormat('dd-MMM-yyyy').format(ts.toDate());
}
String timeFormatter(Timestamp? ts){
  if (ts == null) {
    return 'unknown Date';
  }
  return DateFormat('hh-mm-a').format(ts.toDate());
}

Future<File?> imgSelector()async {
    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if(file != null){
      return File(file.path);
    }
    return null;
}