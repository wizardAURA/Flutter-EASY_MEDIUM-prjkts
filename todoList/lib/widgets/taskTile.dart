import 'package:flutter/material.dart';


class Tasktile extends StatelessWidget{
 final bool  isChecked ;
 final String taskTitle;
 final VoidCallback longpresscallback;
 final  ValueChanged<bool?> checkboxCallback;
 Tasktile(this.taskTitle,this.isChecked,this.checkboxCallback,this.longpresscallback);
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      onLongPress: longpresscallback,
      title: Text(taskTitle,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          decoration: isChecked? TextDecoration.lineThrough:null
        ),),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkboxCallback,
        // onChanged: checks,
      ),
    );
  }
}


