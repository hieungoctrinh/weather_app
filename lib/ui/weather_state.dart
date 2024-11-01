enum WeatherState {
  rain('rain'),
  partiallyCloudy('partly-cloudy-day'),
  overcast('Overcast');

  final String code;
  const WeatherState(this.code);

  static WeatherState getEnumFromCode(String inputCode) {
    return WeatherState.values.firstWhere(
      (element) => element.code == inputCode,
    );
  }
}

extension WeatherStateExtension on WeatherState {
  String get image {
    switch (this) {
      case WeatherState.rain:
        return 'lightrain';
      case WeatherState.partiallyCloudy:
        return 'lightcloud';
      case WeatherState.overcast:
        return 'overcast';
    }
  }
}
