import 'package:flutter/material.dart';
import 'package:provi/providr.dart';
import 'package:provider/provider.dart';

class vertical extends StatefulWidget {
  const vertical({super.key});

  @override
  State<vertical> createState() => _verticalState();
}

class _verticalState extends State<vertical> {
  @override
  Widget build(BuildContext context) {
    return  Consumer<Numbers>(
      builder:(context,numb,child)=> Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
            numb.add();
        },child: Icon(Icons.add),),
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: Container(
          height: 200,
          width: double.maxFinite,
          child: Column(
          children: [
            Text(numb.number.last.toString()),
            Expanded(
              child: ListView.builder(itemCount: numb.number.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return Text(numb.number[index].toString());
              },),
            )
          ],
        ),
        ) ,
      ),
    );
  }
}
