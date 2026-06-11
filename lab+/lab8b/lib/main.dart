import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherCompanionApp());
}

// A fixed list of cities keeps the demo simple and avoids extra geocoding code.
class CityOption {
  final String name;
  final double latitude;
  final double longitude;

  const CityOption({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class WeatherSnapshot {
  final CityOption city;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final int weatherCode;

  const WeatherSnapshot({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });
}

class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  Future<WeatherSnapshot> fetchWeather(CityOption city) async {
    final Uri
    url = Uri.https('api.open-meteo.com', '/v1/forecast', <String, String>{
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'current':
          'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code',
      'timezone': 'auto',
    });

    final http.Response response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Could not load weather data.');
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> current =
        json['current'] as Map<String, dynamic>;

    return WeatherSnapshot(
      city: city,
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
    );
  }

  void dispose() {
    client.close();
  }
}

const List<CityOption> cityOptions = <CityOption>[
  CityOption(name: 'Hanoi', latitude: 21.0285, longitude: 105.8542),
  CityOption(name: 'Da Nang', latitude: 16.0544, longitude: 108.2022),
  CityOption(name: 'Ho Chi Minh City', latitude: 10.8231, longitude: 106.6297),
  CityOption(name: 'Tokyo', latitude: 35.6762, longitude: 139.6503),
];

class WeatherCompanionApp extends StatelessWidget {
  const WeatherCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 8B Weather Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6C9E)),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherService weatherService;
  late Future<WeatherSnapshot> weatherFuture;
  CityOption selectedCity = cityOptions.first;

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService();
    weatherFuture = weatherService.fetchWeather(selectedCity);
  }

  @override
  void dispose() {
    weatherService.dispose();
    super.dispose();
  }

  void loadWeather() {
    setState(() {
      weatherFuture = weatherService.fetchWeather(selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Companion'),
        actions: <Widget>[
          IconButton(onPressed: loadWeather, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Choose a city and get a quick recommendation for the day.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CityOption>(
              initialValue: selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: cityOptions.map((CityOption city) {
                return DropdownMenuItem<CityOption>(
                  value: city,
                  child: Text(city.name),
                );
              }).toList(),
              onChanged: (CityOption? value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedCity = value;
                  weatherFuture = weatherService.fetchWeather(selectedCity);
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<WeatherSnapshot>(
                future: weatherFuture,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<WeatherSnapshot> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.cloud_off, size: 48),
                              const SizedBox(height: 12),
                              const Text('Could not load weather data.'),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: loadWeather,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final WeatherSnapshot weather = snapshot.data!;

                      return ListView(
                        children: <Widget>[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    weather.city.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${weather.temperature.toStringAsFixed(1)}°C',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(weatherDescription(weather.weatherCode)),
                                  const SizedBox(height: 12),
                                  Text(
                                    buildRecommendation(weather),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: <Widget>[
                              MetricCard(
                                label: 'Feels like',
                                value:
                                    '${weather.feelsLike.toStringAsFixed(1)}°C',
                              ),
                              MetricCard(
                                label: 'Humidity',
                                value:
                                    '${weather.humidity.toStringAsFixed(0)}%',
                              ),
                              MetricCard(
                                label: 'Wind',
                                value:
                                    '${weather.windSpeed.toStringAsFixed(1)} km/h',
                              ),
                            ],
                          ),
                        ],
                      );
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String buildRecommendation(WeatherSnapshot weather) {
    if (<int>{
      51,
      53,
      55,
      61,
      63,
      65,
      80,
      81,
      82,
    }.contains(weather.weatherCode)) {
      return 'Recommendation: Bring an umbrella today.';
    }

    if (weather.temperature >= 32) {
      return 'Recommendation: It is quite hot, so light clothes and water are a good idea.';
    }

    if (weather.windSpeed >= 25) {
      return 'Recommendation: It is windy, so outdoor plans may feel uncomfortable.';
    }

    return 'Recommendation: Nice weather for a walk or a casual outing.';
  }

  String weatherDescription(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return 'Rainy';
      default:
        return 'Mixed weather';
    }
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const MetricCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
