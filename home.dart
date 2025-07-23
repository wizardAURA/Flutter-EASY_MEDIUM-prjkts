import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/addnew_Tasks.dart';
import 'package:firebase_project/utils.dart';
import 'package:firebase_project/widgets/dateSelector.dart';
import 'package:firebase_project/widgets/taskCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class homePage extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder:(context) => homePage());
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: Text('My Tasks'),
  centerTitle: true,
      actions: [
        IconButton(onPressed: (){
        Navigator.push(context, add_tasks.route());
        }, icon: Icon(CupertinoIcons.add))
      ],
  ),
    body: Center(child: Column(
      children: [
        const Dateselector(),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("tasks").where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder:(context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!snapshot.hasData){
              return const Text('No tasks found');
            }
            return Expanded(child: ListView.builder( itemCount: snapshot.data!.docs.length ,itemBuilder: (context , index){

            return Dismissible(
              key: ValueKey(snapshot.data!.docs[index].id),
              onDismissed: (direction)async {
                if(direction == DismissDirection.endToStart){
                 await FirebaseFirestore.instance.collection('tasks').doc(snapshot.data!.docs[index].id).delete();
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Task Deleted'))
                 );
                }
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete,color: Colors.white,),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: taskCard(color:Color (snapshot.data!.docs[index].data()['color']),
                        headerText:  snapshot.data!.docs[index].data()['title'],
                        descriptionText:  snapshot.data!.docs[index].data()['description'],
                        scheduledDate:  dateFormatter(snapshot.data!.docs[index].data()['date'],)
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: strengthenColor(
                    Color( snapshot.data!.docs[index].data()['color']),
                        0.68
                      ),
                      image: snapshot.data!.docs[index].data()['imageUrl'] == null
                      ? null : DecorationImage(image: NetworkImage(snapshot.data!.docs[index].data()['imageUrl']),
                      fit: BoxFit.cover),
                      shape: BoxShape.circle,
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      timeFormatter(snapshot.data!.docs[index].data()['date']),
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  )
                ],
              ),
            );

          }),
          );
          },
        )
      ],
    ),),

  );
  }
}
