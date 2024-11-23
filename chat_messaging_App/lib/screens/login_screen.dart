import 'package:chat_messaging_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
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
                decoration: kInputTextfieldDecorations
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                password = value;
                },
                decoration: kInputTextfieldDecorations.copyWith(hintText: 'Enter password...')
              ),
              SizedBox(
                height: 24.0,
              ),
              kblueBtn(data: 'Login', onpressed: ()async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.signInWithEmailAndPassword(
                      email: email!, password: password!);
                  if(newUser != null){
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
