import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/widgets/taskData.dart';

class bottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? Tasktitle;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         
          children: [
            const Text('Add Task',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.lightBlueAccent
            ),),
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              autocorrect: true,
              onChanged: (newText){
                Tasktitle = newText;
              },
            ),

            ElevatedButton(onPressed: (){
              Provider.of<taskData>(context,listen: false).addTask(Tasktitle!);
              Navigator.pop(context);

            }, child: const Text('Add',
            style: TextStyle(
              color: Colors.white
            ),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent
            ),)
          ],
        ),
      ),
    );
  }
}
