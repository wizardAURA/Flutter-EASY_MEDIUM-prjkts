import 'package:flutter/material.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 40.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);
const kTextfielddecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon:Icon(Icons.map_rounded,color: Colors.white,),
    hintText: 'CityName',
    hintStyle: TextStyle(
        color: Colors.black26
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
          Radius.circular(30)
      ),
      borderSide: BorderSide.none,
    )
);