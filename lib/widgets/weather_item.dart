import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:weather_app/models/constants.dart';

class weatherItem extends StatelessWidget {
  const weatherItem({
    Key? key,
    required this.value,
    required this.text,
    required this.unit,
    required this.imageUrl,
  }) : super(key: key);

  final int value;
  final String text;
  final String unit;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Column(
      children: [
        Container(
          child: CircularPercentIndicator(
            radius: 50.0,
            animation: true,
            animationDuration: 1200,
            lineWidth: 15.0,
            percent: value / 100,
            center: Image.asset(imageUrl, width: 40, height: 40),
            footer: Text(
              value.toString() + unit,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.butt,
            backgroundColor: Colors.white,
            progressColor: myConstants.primaryColor,
          ),
        ),
      ],
    );
  }
}
