import 'package:flutter/material.dart';
import 'package:untitled1111/screens/city_screen.dart';
import 'package:untitled1111/utilities/constants.dart';
import 'package:untitled1111/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.LocationData});
  final  LocationData;
  @override
  _LocationScreenState createState() => _LocationScreenState();

}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather =  WeatherModel();
  int? temp;
  String? weatherIcon;
  String? cityName;
  String? wethInfo;
    @override
  void initState() {

    super.initState();
    updateUI(widget.LocationData);
  }
  void updateUI(dynamic weatherdata){
      setState(() {
        if(weatherdata == null){
        temp = 0;
        weatherIcon= 'Error';
        wethInfo = 'unable to fetch location';
        cityName='';
        return;
        }
        double temperature = weatherdata['main']['temp'];
        temp = temperature.toInt();
        var condition = weatherdata['weather'][0]['id'];
        weatherIcon= weather.getWeatherIcon(condition!);
        cityName = weatherdata['name'];
        wethInfo = weather.getMessage(temp!);
      });
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async{
                      var weatherData = await  weather.getlocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 50.0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: ()async {
                     var typedName = await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      }));
                     if(typedName != null){
                     var weatherData = await weather.getCityweather(typedName);
                     updateUI(weatherData);
                     }


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent
                    ),
                    child: Icon(
                      Icons.map_rounded,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$wethInfo in $cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
