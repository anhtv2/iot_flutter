import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:SmartHome/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherContainer extends StatefulWidget {
  final String ownerEmail;
  final String token;
  const WeatherContainer({Key? key, required this.token, required this.ownerEmail}) : super(key: key);

  @override
  State<WeatherContainer> createState() => _WeatherContainerState();
}

class _WeatherContainerState extends State<WeatherContainer> {
  String temperature = '28°C';
  String humidity = '50%';

  late Timer timer;

  Future<void> initWeatherData() async {
    var response = await http.get(
      Uri.https('iotbackend.vercel.app', 'api/statistics', {'ownerEmail': widget.ownerEmail}),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      temperature = '${data['temperature'].toStringAsFixed(1)}°C';
      humidity = '${data['humidity'].toStringAsFixed(1)}%';
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState()  {
    super.initState();

    initWeatherData();

    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      var response = await http.get(
        Uri.https('iotbackend.vercel.app', 'api/statistics', {'ownerEmail': widget.ownerEmail}),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        temperature = '${data['temperature'].toStringAsFixed(1)}°C';
        humidity = '${data['humidity'].toStringAsFixed(1)}%';
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: getProportionateScreenHeight(80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
              vertical: getProportionateScreenHeight(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // SizedBox(
                //   width: getProportionateScreenWidth(90),
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.thermostat,
                      color: Colors.black,
                      size: 50,
                    ),
                    // SizedBox(
                    //   width: getProportionateScreenWidth(10),
                    // ),
                    Text(
                      temperature,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.black,
                      size: 50,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Text(
                      humidity,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
