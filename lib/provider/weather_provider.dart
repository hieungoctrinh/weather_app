import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/ui/weather_state.dart';

class WeatherProvider with ChangeNotifier {
  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int precipprob = 0;
  int windSpeed = 0;
  var currentDate = 'Loading..';
  String imageUrl = '';
  String location = 'London';

  List<dynamic> forecastDays = [];
  List consolidatedWeatherList = [];

  var selectedCities = City.getSelectedCities();
  List<String> cities = ['London'];
  String? errorMessage;

  final String baseUrl =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/';
  final String apiKey = 'YCVZZSMMKNN59RN74H9VEQDH4';

  // Hàm tìm kiếm và lấy thông tin vị trí
  Future<void> fetchLocation(String location) async {
    errorMessage = null;

    await fetchWeatherData(location);
  }

  // Hàm lấy dữ liệu thời tiết từ API cho vị trí đã chọn
  Future<void> fetchWeatherData(String location) async {
    try {
      var response = await http.get(Uri.parse(
          '$baseUrl$location?unitGroup=metric&key=$apiKey&contentType=json'));
      var result = json.decode(response.body);
      var consolidateWeather = result['days'];

      for (int i = 0; i < 7; i++) {
        consolidateWeather.add(consolidateWeather[i]);
        weatherStateName = consolidateWeather[0]['icon'];
        print(weatherStateName);
        temperature = consolidateWeather[0]['temp'].round();
        print(temperature);
        maxTemp = consolidateWeather[0]['tempmax'].round();
        print(maxTemp);
        humidity = consolidateWeather[0]['humidity'].round();
        print(humidity);
        windSpeed = consolidateWeather[0]['windspeed'].round();
        print(windSpeed);
        precipprob = consolidateWeather[0]['precipprob'].round();
        print(precipprob);

        var myDate = DateTime.parse(consolidateWeather[0]['datetime']);
        currentDate = DateFormat('EEE MMM dd, yyyy').format(myDate);

        consolidatedWeatherList = consolidateWeather.toSet().toList();

        final listWeatherState = weatherStateName.split(',');
        log(listWeatherState.toString());

        final listEnumState = listWeatherState
            .map((element) => WeatherState.getEnumFromCode(element.trim()))
            .toList();
        log(listEnumState.toString());

        imageUrl = listEnumState.first.image;

        consolidatedWeatherList = consolidateWeather.toSet().toList();
        notifyListeners();
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
