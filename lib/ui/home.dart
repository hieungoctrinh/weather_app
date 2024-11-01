import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Models/constants.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/ui/detail_page.dart';
import 'package:weather_app/widgets/weather_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Constants myConstants = Constants();

  @override
  void initState() {
    final WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    if (weatherProvider.cities.isNotEmpty) {
      weatherProvider.fetchLocation(weatherProvider.cities[0]);
      weatherProvider.fetchWeatherData(weatherProvider.cities[0]);
    }

    for (int i = 0; i < weatherProvider.selectedCities.length; i++) {
      weatherProvider.cities.add(weatherProvider.selectedCities[i].city);
    }
    super.initState();
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/profile.png',
                  width: 40,
                  height: 40,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(width: 4),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: weatherProvider.location,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: weatherProvider.cities.map((String location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          weatherProvider.location = newValue!;
                          weatherProvider
                              .fetchLocation(weatherProvider.location);
                          weatherProvider
                              .fetchWeatherData(weatherProvider.location);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100, // Set a fixed height for the horizontal ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherProvider.consolidatedWeatherList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String today =
                        DateFormat('yyyy-MM-dd').format(DateTime.now());
                    var selectedDay = DateFormat('yyyy-MM-dd').format(
                      DateTime.parse(weatherProvider
                          .consolidatedWeatherList[index]['datetime']),
                    );
                    var parsedDate = DateTime.parse(weatherProvider
                        .consolidatedWeatherList[index]['datetime']);
                    var newDate = DateFormat('EEE').format(parsedDate);

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  consolidatedWeatherList:
                                      weatherProvider.consolidatedWeatherList,
                                  selectedId: index,
                                  location: weatherProvider.location,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            width: 80,
                            decoration: BoxDecoration(
                                gradient: selectedDay == today
                                    ? myConstants.myGradient
                                    : null,
                                color: selectedDay != today
                                    ? const Color.fromARGB(255, 9, 51, 167)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 5,
                                    color: selectedDay == today
                                        ? myConstants.primaryColor
                                        : const Color.fromARGB(137, 73, 65, 65)
                                            .withOpacity(.2),
                                  ),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${weatherProvider.consolidatedWeatherList[index]['temp'].round()}°C',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  newDate,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                ),
              ),

              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/${weatherProvider.imageUrl}.png',
                  width: 150,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        weatherProvider.temperature.toString(),
                        style: const TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 11, 87, 149),
                        ),
                      ),
                    ),
                    const Text(
                      '°',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 11, 87, 149),
                      ),
                    ),
                    const Text(
                      'C',
                      style: TextStyle(
                        fontSize: 80,
                        color: const Color.fromARGB(255, 11, 87, 149),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  weatherProvider.weatherStateName.toUpperCase(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 67, 143, 205),
                    fontSize: 30.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  weatherProvider.currentDate,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Weather info items
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    weatherItem(
                      text: 'Humidity',
                      value: weatherProvider.humidity,
                      unit: '%',
                      imageUrl: 'assets/humidity.png',
                    ),
                    weatherItem(
                      text: 'Wind Speed',
                      value: weatherProvider.precipprob,
                      unit: '%',
                      imageUrl: 'assets/lightrain.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Stack calendar(WeatherProvider weatherProvider) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -40,
          left: 20,
          child: weatherProvider.imageUrl == ''
              ? const Text('')
              : Image.asset(
                  'assets/${weatherProvider.imageUrl}.png',
                  width: 150,
                ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          child: Text(
            weatherProvider.weatherStateName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  weatherProvider.temperature.toString(),
                  style: TextStyle(
                    fontSize: 80,
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
              ),
              Text(
                '°C',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = linearGradient,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
