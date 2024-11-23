import 'package:flutter/material.dart';
import 'package:todolist/widgets/Tasklist.dart';
import 'package:todolist/widgets/bottomsheet.dart';
import 'package:todolist/widgets/taskData.dart';
import 'package:provider/provider.dart';


class Tasksscreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(context: context, builder: (context)=>bottomSheet(
        )
        );
      },
      backgroundColor: Colors.lightBlueAccent,
      child: const Icon(Icons.add,color: Colors.white,),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:  const EdgeInsets.only(top: 60,
            left: 30,
            right: 30,
            bottom: 30),
            child:   Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(child: Icon(Icons.list,color: Colors.lightBlueAccent, size: 30,),
                backgroundColor: Colors.white,
                radius: 30,),
                const SizedBox(height: 10,),
                const Text('Todoey',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w700
                ),),
                Text('${Provider.of<taskData>(context).taskCount} tasks',
                style:const TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                  )
              ),
              child: Taskslist(),
            ),
          )
        ],
      ),
    );
  }
}