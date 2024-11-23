import 'package:flutter/material.dart';
import 'Quiz.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
QuizBrain qizBrain = QuizBrain();
void main() => runApp( const Quizzler());

class Quizzler extends StatelessWidget {
   const Quizzler({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}
class _QuizPageState extends State<QuizPage> {
  void checkAns(bool userPickedans){
    bool correctAns = qizBrain.getQuestionand();
    setState(() {
        if(qizBrain.isFinished() == true){
          Alert(
            context: context,
            title: 'Finished!',
            desc: 'You\'ve reached the end of the quiz.',
          ).show();

          //TODO Step 4 Part C - reset the questionNumber,
          qizBrain.reset();

          //TODO Step 4 Part D - empty out the scoreKeeper.
          scoreKeeper = [];
        }
      else{
      if (userPickedans == correctAns){
        scoreKeeper.add(Icon(Icons.check, color: Colors.green,));
      }else{
        scoreKeeper.add(Icon(Icons.close,color: Colors.red,));
      }
      }

      qizBrain.nxtQues();
    });
  }

  List<Icon> scoreKeeper = [
  ];


  @override

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                qizBrain.getQuetionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
                ),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAns(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAns(false);
              },
            ),
          ),
        ),
        //TODO: Add a Row here as your score keeper
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/