import 'package:untitled1111/services/location.dart';
import 'package:untitled1111/services/networking.dart';
const openWeatherURL = 'https://api.openweathermap.org/data/2.5/weather';
const apiKey = '4cbd1de1ddbf8612471ef9fe436312e7';

class WeatherModel {
  Future<dynamic> getCityweather(String cityName) async{
    Networkhelper networkhelper = Networkhelper('$openWeatherURL?q=$cityName&appid=$apiKey&units=metric');
    var weatherData =await networkhelper.getData();
    return weatherData;

  }
  Future<dynamic> getlocationWeather()async{
    Loc location = Loc();
    await location.getcurloc();

    Networkhelper networkhelper = Networkhelper('$openWeatherURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherData = await networkhelper.getData();
    return weatherData;
  }
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
