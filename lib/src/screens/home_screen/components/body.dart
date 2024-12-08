import 'dart:convert';
import 'dart:io';

import 'package:SmartHome/config/size_config.dart';
import 'package:SmartHome/src/screens/home_screen/components/weather_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_device_widget.dart';
import 'dark_container.dart';

class Body extends StatefulWidget {
  final String ownerEmail;
  final String token;
  dynamic devices;
  Body({Key? key, required this.devices, required this.token, required this.ownerEmail}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<void> updateDevices() async {
    var response = await http.get(
      Uri.https('iotbackend.vercel.app', 'api/device/get-all', {'ownerEmail': widget.ownerEmail}),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer ${widget.token}"
      },
    );

    if(response.statusCode == 200){
      var newDevices = jsonDecode(response.body);
      setState(() {
        widget.devices = newDevices['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(7),
          vertical: getProportionateScreenHeight(7),
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(getProportionateScreenHeight(5)),
              child: WeatherContainer(token: widget.token, ownerEmail: widget.ownerEmail,),
            ),
            for (int i = 0; i < widget.devices.length; i+=2)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(getProportionateScreenHeight(5)),
                      child: DarkContainer(
                        id: widget.devices[i]['id'],
                        isOn: widget.devices[i]['isOn'],
                        type: widget.devices[i]['type'],
                        description: widget.devices[i]['description'],
                        updateDevices: updateDevices,
                        token: widget.token,
                      ),
                    ),
                  ),
                  if (i + 1 < widget.devices.length)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(getProportionateScreenHeight(5)),
                        child: DarkContainer(
                          id: widget.devices[i + 1]['id'],
                          isOn: widget.devices[i + 1]['isOn'],
                          type: widget.devices[i + 1]['type'],
                          description: widget.devices[i + 1]['description'],
                          updateDevices: updateDevices,
                          token: widget.token,
                        ),
                      ),
                    )
                  else
                    Expanded(child: Container()),
                ],
              ),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenHeight(8)),
              child:  AddNewDevice(updateDevices: updateDevices, token: widget.token, ownerEmail: widget.ownerEmail,),
            ),
          ],
        ),
      ),
    );
  }
}
