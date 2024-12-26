import 'package:flutter/material.dart';

class Numbers extends ChangeNotifier{
  List<int> number = [0];

  void add (){
    int last = number.last;
    number.add(last+1);
    notifyListeners();
  }

}