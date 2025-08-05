import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/SignUppage.dart';
import 'package:firebase_project/home.dart';
import 'package:firebase_project/widgets/kreusables.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute( builder:(context)
  =>  LoginPage(),);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  Future<bool> logIn()async{
    try{
      final userCredintial = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim());
      print(userCredintial);
      return true;
    }
    on FirebaseAuthException catch(e){
      print(e.message);
      return false;
    }
  }
@override
  void dispose() {
  emailcontroller.dispose();
  passwordcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: const Text(
                  'Sign In.',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              kTextformfield(emailcontroller,'email'),
              const SizedBox(height: 15),
              kTextformfield(passwordcontroller,'password'),
               SizedBox(height: 20),
             kbtns( Text('Log In', style: TextStyle(color: Colors.white),),  () async{
              final success =  await logIn();
             if (success){
               Navigator.push(context, homePage.route());
             }
             }, Colors.white),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, Signuppage.route());
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
