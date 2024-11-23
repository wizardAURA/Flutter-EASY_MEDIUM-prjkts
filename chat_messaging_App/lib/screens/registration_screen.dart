//import 'package:chat_messaging_app/screens/chat_screen.dart';
import 'chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_messaging_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool  showSpinner= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo_transition',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                 email = value;
                },
                  style: TextStyle(),
                decoration:kInputTextfieldDecorations
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                password = value;
                },
                decoration: kInputTextfieldDecorations.copyWith(hintText: 'Enter password...')
              ),
              SizedBox(
                height: 24.0,
              ),
              kblueBtn(data: 'Register', onpressed: ()async {
              setState(() {
                showSpinner = true;
              });
                try{
                  final newUser = await  _auth.createUserWithEmailAndPassword(email: email!, password: password!);
                  if (newUser != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }
         catch(e){
                  print(e);
         }
         setState(() {
           showSpinner = false;
         });
              }, colour: Colors.blueAccent)
            ],
          ),
        ),
      ),
    );
  }
}
