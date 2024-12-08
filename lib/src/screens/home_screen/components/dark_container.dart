import 'dart:convert';
import 'dart:io';

import 'package:SmartHome/config/size_config.dart';
import 'package:SmartHome/src/screens/edit_device/edit_device.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DarkContainer extends StatefulWidget {
  final String token;
  final String id;
  final String type;
  String description;
  bool isOn;
  final VoidCallback? updateDevices;
  DarkContainer({
    Key? key,
    required this.type,
    required this.description,
    required this.isOn,
    required this.id,
    this.updateDevices,
    required this.token,
  }) : super(key: key);

  @override
  State<DarkContainer> createState() => _DarkContainerState();
}

class _DarkContainerState extends State<DarkContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(140),
      height: getProportionateScreenHeight(140),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.isOn
            ? const Color.fromRGBO(0, 0, 0, 1)
            : const Color(0xffededed),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
          vertical: getProportionateScreenHeight(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.isOn
                        ? const Color.fromRGBO(45, 45, 45, 1)
                        : const Color(0xffdadada),
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(45, 45)),
                  ),
                  child: Icon(
                    widget.type == 'Light' ? (widget.isOn ? Icons.lightbulb : Icons.lightbulb_outline) :
                    (widget.type == 'Air Conditioner' ? (widget.isOn ? Icons.ac_unit : Icons.ac_unit_outlined) :
                    (widget.type == 'Fan' ? (widget.isOn ? Icons.wind_power : Icons.mode_fan_off_outlined) :
                    (widget.type == 'TV' ? (widget.isOn ? Icons.tv : Icons.tv_off) :
                    (widget.type == 'Door' ? (widget.isOn ? Icons.door_sliding : Icons.door_front_door) :
                    (widget.type == 'Window' ? (widget.isOn ? Icons.window : Icons.window_sharp) :
                    (widget.type == 'Washing Machine' ? (widget.isOn ? Icons.wash : Icons.wash_outlined) :
                    (widget.type == 'Refrigerator' ? (widget.isOn ? Icons.kitchen : Icons.kitchen_outlined) :
                    (widget.type == 'Microwave' ? (widget.isOn ? Icons.microwave : Icons.microwave_outlined) :
                    (widget.isOn ? Icons.memory : Icons.memory_outlined))))))))),
                    color: widget.isOn ? Colors.white : Colors.black,
                    size: 40,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String? status = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        EditDevice(id: widget.id, type: widget.type, description: widget.description, token: widget.token,), maintainState: false));

                    if (status != null){
                      if (status == 'delete') {
                        widget.updateDevices!();
                      }
                      else{
                        setState(() {
                          widget.description = status;
                        });
                      }
                    }
                  },
                  child:  const Icon(
                    Icons.edit,
                    color: Color(0xFF808080),
                    size: 30,
                    // color: Color(0xFF808080),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.type,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: widget.isOn ? Colors.white : Colors.black,
                      ),
                ),
                Text(
                  widget.description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Color.fromRGBO(166, 166, 166, 1),
                      fontSize: 13,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.6),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.type == 'Door' ? (widget.isOn ? 'Open' : 'Close') :
                  (widget.isOn ? 'On' : 'Off'),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: widget.isOn ? Colors.white : Colors.black,
                      ),
                ),
                InkWell(
                  onTap: () async {
                    var response = await http.put(
                      Uri.https('iotbackend.vercel.app', 'api/device/status'),
                      headers: {
                        HttpHeaders.authorizationHeader: "Bearer ${widget.token}",
                        'Content-Type': 'application/json; charset=UTF-8'
                      },
                      body: jsonEncode({
                        'deviceId': widget.id,
                        'isOn': !widget.isOn,
                      }),
                    );

                    setState(() {
                      widget.isOn = !widget.isOn;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 25.6,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.isOn ? Colors.black : const Color(0xffd6d6d6),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        width: widget.isOn ? 2 : 0,
                      ),
                    ),
                    child: Row(
                      children: [
                        widget.isOn ? const Spacer() : const SizedBox(),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
