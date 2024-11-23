
import 'dart:math';
class BMImaths{
  BMImaths({this.weight,required this.height});
  final int height;
  final weight;
  late double _bmi;
  String calculateBMI(){
    _bmi = weight/pow(height/100, 2);
    return _bmi.toStringAsFixed(1);

  }
   String getresult(){
    if (_bmi>=25){
      return 'overweight';
    }
    else if (_bmi> 18.5){
      return 'Normal';
    }
    else  {
      return 'underweight';
    }
   }
   String getinterption(){
     if (_bmi>=25){
       return 'you fat pig';
     }
     else if (_bmi> 18.5){
     return 'Niceeeee';
     }
     else  {
     return 'you sukha lakdi';
     }
   }
}