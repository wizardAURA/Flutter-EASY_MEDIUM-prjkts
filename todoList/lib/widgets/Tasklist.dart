import 'package:flutter/material.dart';
import 'package:todolist/widgets/taskData.dart';
import 'taskTile.dart';
import 'package:provider/provider.dart';
class Taskslist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<taskData>(builder: (context,taskData,child){
      return ListView.builder(itemBuilder: (context,index){
        return Tasktile(taskData.tasks[index].name.toString(),
           taskData.tasks[index].isDone,
                (newValuecheck) {
              taskData.updateTask(taskData.tasks[index]);
            },
                  (){
                  taskData.deleteTask(taskData.tasks[index]);
            }
            );

      },
        itemCount: taskData.taskCount,
      );
    },

    );
  }
}