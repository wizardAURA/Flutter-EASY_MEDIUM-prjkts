import 'package:flutter/material.dart';
import 'package:provi/providr.dart';
import 'package:provi/verticalhome.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return  Consumer<Numbers>(
      builder:(context,numModel,child)=>
        Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          numModel.add();
        },
        child: const Icon(Icons.add),),
        appBar: AppBar(backgroundColor: Colors.blue,),
        body: Container(
          child: Column(
            children: [
              Text(numModel.number.last.toString()),
              Expanded(
                child: ListView.builder(itemCount: numModel.number.length ,
                itemBuilder: (context,index){
                  return Text(numModel.number[index].toString());
                },),
              ),
              TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>vertical() ));
              },
              child: Text('proceed'),
            )
            ],
      
          ),
        ),
      ),
    );
  }
}
