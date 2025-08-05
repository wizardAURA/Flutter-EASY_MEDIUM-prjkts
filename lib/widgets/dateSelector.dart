import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dateselector extends StatefulWidget {
  const Dateselector({super.key});

  @override
  State<Dateselector> createState() => _DateselectorState();
}

class _DateselectorState extends State<Dateselector> {
  DateTime selecteddate = DateTime.now();
  int weekoffset = 0;

  List<DateTime> generateweekdates(int weekoffset){
    final today = DateTime.now();
    DateTime startofWeek = today.subtract(Duration(days: today.weekday - 1 )).add(Duration(days: 7 * weekoffset));
    return  List.generate(7, (index) => startofWeek.add(Duration(days: index)));
  }
  @override
  Widget build(BuildContext context) {
  List<DateTime> weekdates = generateweekdates(weekoffset);
  String monthName = DateFormat('MMMM').format(weekdates.first);
    return Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             IconButton(onPressed: (){
               setState(() {
                 weekoffset--;
               });
             }, icon: Icon(Icons.arrow_back_ios)),
             Text(monthName,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
             ),
             IconButton(onPressed: (){
               setState(() {
                 weekoffset++;
               });
             }, icon: Icon(Icons.arrow_forward_ios)),
           ],
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
            height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,itemCount: weekdates.length,itemBuilder:(context, index){
           DateTime date = weekdates[index];
           bool isSelected = DateFormat('d').format(date) == DateFormat('d').format(selecteddate)
           && selecteddate.month == date.month && selecteddate.year == date.year;
           return GestureDetector(
             onTap: (){
               setState(() {
                 selecteddate = date;
               });
             },
             child: Container(
               width: 70,
               margin: EdgeInsets.only(right:8),
               decoration: BoxDecoration(
                 color: isSelected? Colors.deepOrangeAccent : Colors.transparent,
                 borderRadius: BorderRadius.circular(10),
                 border: Border.all(
                   color: isSelected?Colors.deepOrangeAccent:  Colors.grey.shade300,
                   width: 2
                 )

               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected? Colors.white : Colors.black,
                        ),
                      ),
                   const SizedBox(
                     height: 3,
                   ),
                   Text(
                     DateFormat('E').format(date),
                     style: TextStyle(
                       fontSize: 14,
                       fontWeight: FontWeight.w600,
                       color: isSelected? Colors.white : Colors.black,
                     ),
                   ),
                 ],
               )


             ),
           );
          })
        ),)

      ],
    ) ;
  }
}
