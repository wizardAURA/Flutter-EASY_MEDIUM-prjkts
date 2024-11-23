import 'package:bmi_calc/Resultpg.dart';
import  'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'BMImths.dart';
import 'carddetails.dart';
import 'Card.dart';
import 'style.dart';

const bottomcontainerheight = 80.0;
enum Gender{
  male,
  female
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender? gender;
  int height = 120;
  int weight = 30;
  int Age = 0;
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E6973),

      appBar:
      AppBar(
        elevation: 8,
        title: const Center(child: Text('BMI CALCULATOR')
        ),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Row(
            children: [
              Expanded(child: Carde(
            onpress: (){
              setState(() {
                gender = Gender.male;
              });
            },
                colour: gender == Gender.male?
                        kactiveclrmale : kcardcolor,
              childcar:
              crdetail(label: 'Male', icon: FontAwesomeIcons.mars),
              ),),
              Expanded(child: Carde(onpress: (){
                setState(() {
                  gender = Gender.female;
                });},
                  colour: gender == Gender.female ?
                          kacriveclrfemale : kcardcolor,
              childcar:
                crdetail(label: 'Female', icon: FontAwesomeIcons.venus)
              ),)
            ],
          ),
          ),
          Expanded(child: Carde(onpress: (){}, colour: kcardcolor,
          childcar:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('HEIGHT', style: kstyletext,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(height.toString(),
                style: knumbertxtstye,),
                Text('cm',
                style: kstyletext,),
              ],
            ),
              SliderTheme(data: SliderTheme.of(context).copyWith(
                overlayColor: Color(0x2918A4AF),
                thumbColor:  Color(0xFF10767E),
                activeTrackColor:  Color(0xFF18A4AF),
              )
                  , child:
              Slider(value: height.toDouble(),
                min: 0.0,
                max:220.0 ,

              inactiveColor: Color(0xff021d1e),
              onChanged: (double newvalue){
               setState(() {
                 height = newvalue.round();
               });
              },)
              ),
            ],
          ),),),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Carde(onpress: (){}, colour: kcardcolor,
                childcar:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('WEIGHT',
                    style: kstyletext,),
                    Text(weight.toString(),
                      style: knumbertxtstye,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Roundiconbtn(icon: FontAwesomeIcons.plus, onpressed: (){
                          setState(() {
                            weight++;
                          });
                        },),
                          SizedBox(width: 12,),
                        Roundiconbtn(icon: FontAwesomeIcons.minus,
                        onpressed: (){
                          setState(() {
                            if(weight>0){
                              weight--;
                            }
                          });
                        },)

                      ],
                    )
                  ],
                ),),
                ),
                Expanded(child: Carde(onpress: (){}, colour: kcardcolor,
                childcar:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('AGE',
                    style: kstyletext,),
                    Text(Age.toString(),
                    style: knumbertxtstye,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Roundiconbtn(icon: FontAwesomeIcons.plus, onpressed: (){
                        setState(() {
                          if(Age<120){
                            Age++;
                          }
                        },);
                      },),
                        SizedBox(
                         width: 12,),
                        Roundiconbtn(icon: FontAwesomeIcons.minus, onpressed: (){
                          setState(() {
                            if(Age>0){
                              Age--;
                            }

                          });
                        })
                    ],
                    )
                  ],

                ),),
                ),
            
              ],
            ),
          ),
          btmcntnr(buttontitle: 'CALCULATE', ontap: (){
            BMImaths  maths = BMImaths(height: height, weight: weight);
            Navigator.push(context,   MaterialPageRoute(builder: (context) => Resultpg(
              bmiResult: maths.calculateBMI(),
              resultText: maths.getresult(),
              interpretation: maths.getinterption(),
            ) ),);
          },)

        ],
      )
    );
  }
}

class btmcntnr extends StatelessWidget {
  btmcntnr({required this.ontap, required this.buttontitle});
  final Function() ontap;
  final String buttontitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        child: Center(
          child: Text(
            buttontitle,
            style: kbottomtextstyle
          ),
        ),
        color:const Color (0xFF8C4A32),
        width: double.infinity,
        height: bottomcontainerheight,
        margin: const EdgeInsets.only(top: 10),),
    );
  }
}
class Roundiconbtn extends StatelessWidget {

  const Roundiconbtn({required this.icon, required this.onpressed});
final IconData icon;
final Function() onpressed;


  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(onPressed: onpressed,
      child:Icon(icon),
      elevation: 6,
      constraints: BoxConstraints.tightFor(
        width: 45.0,
        height: 45.0,
      ),
    shape: CircleBorder(),
    fillColor: Color(0xFF18A4AF),
    );
  }
}
