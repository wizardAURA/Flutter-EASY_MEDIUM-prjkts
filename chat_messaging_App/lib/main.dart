import 'package:flutter/material.dart';
import 'package:chat_messaging_app/screens/welcome_screen.dart';
import 'package:chat_messaging_app/screens/login_screen.dart';
import 'package:chat_messaging_app/screens/registration_screen.dart';
import 'package:chat_messaging_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat());
}


class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        ChatScreen.id : (context)=> ChatScreen()

      },
    );
  }
}
