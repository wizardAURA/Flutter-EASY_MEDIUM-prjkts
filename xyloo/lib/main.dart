import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
void playsound(String sndNm){
  final player = AudioPlayer();
  player.play(AssetSource('audio/$sndNm.wav'),);
}
    Expanded buildkey({required Color color, required String sound}){
 return Expanded(
    child: ElevatedButton(onPressed: (){
      playsound(sound);
    }, child: const
    Text(''),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),),
  );
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildkey( color: Colors.pinkAccent, sound: 'd4' ),
              buildkey( color: Colors.redAccent, sound: 'a2' ),
              buildkey( color: Colors.blueAccent, sound: 'a4' ),
              buildkey( color: Colors.green, sound: 'c major' ),
              buildkey( color: Colors.purpleAccent, sound: 'c1' ),
              buildkey( color: Colors.yellowAccent, sound: 'cm' ),
              buildkey( color: Colors.orange, sound: 'd0' ),
            ],
          ),

        ),
      ),
    );
  }
}
