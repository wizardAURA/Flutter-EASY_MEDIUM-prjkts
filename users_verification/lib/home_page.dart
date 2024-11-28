import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_verification/add_new_task.dart';
import 'package:users_verification/utils.dart';
import 'package:users_verification/widgets/date_selector.dart';
import 'package:users_verification/widgets/task_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewTask(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
             DateSelector(),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                }

                return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var date = snapshot.data!.docs[index].data()['date'].toDate();
                    var formattedDate = DateFormat('EEE, dd MMM').format(date);
                    return Row(
                      children: [
                         Expanded(
                          child: TaskCard(
                            color: hexToColor(snapshot.data!.docs[index].data()['colour']),
                            headerText:snapshot.data!.docs[index].data()['title'],
                            descriptionText: snapshot.data!.docs[index].data()['description'],
                            scheduledDate: formattedDate,
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: strengthenColor(
                              hexToColor(snapshot.data!.docs[index].data()['colour']),
                              0.69,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            '10:00AM',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}
