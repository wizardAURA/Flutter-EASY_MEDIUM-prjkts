import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/home.dart';
import 'package:firebase_project/widgets/kreusables.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:firebase_project/utils.dart';


class add_tasks extends StatefulWidget {
  static route() => MaterialPageRoute(
  builder: (context) => add_tasks());

  @override
  State<add_tasks> createState() => _add_tasksState();
}

class _add_tasksState extends State<add_tasks> {
  DateTime selectedDate = DateTime.now();
  final titleController = TextEditingController();
  final discriptionController = TextEditingController();
  Color _selectedColor = Colors.blue;
  bool uploading = false;
  File? files;
  @override
  void dispose() {
    titleController.dispose();
    discriptionController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  Future<bool> uploadTasks()async{
    try{
      final id = Uuid().v6();
      final imageRef = FirebaseStorage.instance.ref('Image').child(id);
      final uploadTask = imageRef.putFile(files!);
      final snapShot = await uploadTask;
      final downloadUrl = await snapShot.ref.getDownloadURL();
    final data = await FirebaseFirestore.instance.collection('tasks').doc(id).set({
      "title": titleController.text.trim(),
      "description": discriptionController.text.trim(),
      "date": selectedDate,
      "postedAt": FieldValue.serverTimestamp(),
      "color": _selectedColor.value,
      "creator": FirebaseAuth.instance.currentUser!.uid,
      "id" : id,
      "imageUrl": downloadUrl
    });
    print(id);
    return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new tasks'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async  {
              final seldate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add (const Duration(days: 90)));
              if (seldate != null) {
                setState(() {
                  selectedDate = seldate;
                });
              }
            },
            child: Padding(padding: EdgeInsets.all(8),
            child: Text(DateFormat('MMM dd, yyyy').format(selectedDate),
            ),),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(height: 20),
          kTextformfield(titleController,'Title'),
          SizedBox(height: 10),
          kTextformfield(discriptionController, 'Description',maxLines: 3),
          SizedBox(height: 10,),
         ColorPicker(pickersEnabled: {
           ColorPickerType.wheel: true,
         },
         color: Colors.green,
         onColorChanged: (Color color){
           setState(() {
             _selectedColor = color;
           });
         },
           heading: Text('select Color'),
         subheading: Text('Select a different shade'),),
          SizedBox(height: 10,),

          GestureDetector(onTap: ()async {
            final image = await imgSelector();
            setState(() {
              files = image;
            });
          }, child: DottedBorder( options: RoundedRectDottedBorderOptions(radius: Radius.circular(10),
          dashPattern: [12,8],
          strokeCap: StrokeCap.round),
            child: Container(
              width: double.infinity,
              height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect( borderRadius: BorderRadius.circular(10), child: files != null ? Image.file(files!, ) : const Icon(Icons.camera_alt_rounded,size: 50,)),
            ),
          )),

          SizedBox(height: 20,),
          
          kbtns(uploading
              ? CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)
              : Text('Upload',style: TextStyle(color: Colors.white),), () async{

            if (uploading) return;
            setState(() {
              uploading = true;
            });
            final success =  await uploadTasks();
            setState(() {
              uploading = false;
            });
            if(success){
              Navigator.pushReplacement(context, homePage.route());
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task Upload Failed'))
              );
            }
          }, Colors.white)
        ],
        ),),
      ),
    );
  }
}
