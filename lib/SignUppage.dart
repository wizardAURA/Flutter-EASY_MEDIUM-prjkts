import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_project/widgets/kreusables.dart';
import 'package:flutter/services.dart';

class Signuppage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const Signuppage(),
  );
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  Future<bool> signIn()async {
  try{
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim());
    print(userCredential.user?.uid);
  return true;}
  on FirebaseAuthException catch(e){
    print(e.message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Sign-up failed')),
    );

    return false ; }}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center
              (child: const Text(
              'Sign up',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold
              ),
            ),
            ),
            SizedBox(height: 30),
           kTextformfield( emailcontroller,  'email'),
            SizedBox(height: 30),
            kTextformfield( passwordcontroller,  'password'),

            SizedBox(height: 30),
            kbtns(Text('Sign up', style: TextStyle(color: Colors.white),),()async {
             final success = await signIn();
             if(success){
               Navigator.push(context, LoginPage.route());
             }
            },Colors.white),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(context, LoginPage.route());
              },
              child: RichText(text: TextSpan(
                text: 'Already have an account?',
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  TextSpan(
                    text: 'Log in',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]

              )),
            ),
          ],
        ),
      ),),
    );
  }
}
