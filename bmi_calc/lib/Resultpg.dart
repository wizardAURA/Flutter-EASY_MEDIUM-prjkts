import 'package:flutter/material.dart';
import 'style.dart';
import 'Card.dart';
import 'input_pg.dart';
class Resultpg extends StatelessWidget {
Resultpg({ required this.bmiResult, required this.interpretation, required this.resultText});


  final String bmiResult;
  final String resultText;
  final String interpretation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI CALCULATOR'
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child:
          Container(
            child: Center(
              child: Text(
                'Your Result',
                style: kbottomtextstyle,
              ),
            ),
          ),),
          Expanded(flex: 5,

            child: Carde(colour: kcardcolor,
                childcar: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(resultText.toUpperCase(),
                    style: kresulttext,),
                    Text(bmiResult,
                    style: knumbertxtstye,),
                    Text(interpretation,
                    style: kstyletext,
                    textAlign: TextAlign.center,)
                  ],
            ),
                onpress: (){}),
          ),
          btmcntnr(buttontitle: 'RE-calculate', ontap: (){
            Navigator.push(context,   MaterialPageRoute(builder: (context) => InputPage() ),);
          },)
        ],
      ),
    );
  }
}
