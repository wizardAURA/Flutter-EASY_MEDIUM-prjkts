import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:chat_messaging_app/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
   AnimationController? controller;
   Animation? animation;
@override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync:this,
      upperBound: 1
    );
   animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller!);
   controller?.forward();
    controller?.addListener(()
    {
      setState(() {

      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(

                  tag: 'logo_transition',
                  child: Container(
                    height: 60,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                Text (
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
              kblueBtn(data: 'login', onpressed: (){
                Navigator.pushNamed(context , LoginScreen.id);
              }, colour:Colors.blueAccent),
            kblueBtn(data: 'Register ', onpressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            }, colour: Colors.blueAccent)
          ],
        ),
      ),
    );
  }
}

