import 'dart:convert';
import 'dart:io';

import 'package:SmartHome/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final String ownerEmail;
  final String token;
  const Body({Key? key, required this.token, required this.ownerEmail}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(20),
        bottom: getProportionateScreenHeight(15),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 7),
            child: Row(
              children: [
                const Text(
                  'Add Device',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(50),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  // 'Air Conditioner', 'Window', 'Washing Machine', 'Refrigerator', 'Microwave',
                    items: ['Light', 'Fan', 'Door', 'TV', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    isExpanded: true,
                    hint: const Text("Select type of device"),
                    value: typeController.text.isEmpty ? null : typeController.text,
                    decoration: InputDecoration(
                      icon: Container(
                        height: 50,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      enabled: true,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    onChanged: (selectedValue) {
                      if (selectedValue != null) {
                        setState(() {
                          typeController.text = selectedValue.toString();
                        });
                      }
                    },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: descriptionController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  validator: (value){
                    if(value!.isEmpty || value.trim().isEmpty){
                      return 'Description is required';
                    }
                    return null;
                  },
                  cursorColor: Colors.black12,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: const TextStyle(color: Colors.grey),
                    icon: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    enabled: true,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Container(
            height: getProportionateScreenHeight(40),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () async {
                if(_formKey.currentState!.validate()){
                  var response = await http.post(
                    Uri.https('iotbackend.vercel.app', 'api/device/add'),
                    headers: {
                      HttpHeaders.authorizationHeader: "Bearer ${widget.token}",
                      'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: jsonEncode({
                      'type': typeController.text,
                      'isOn': false,
                      'description': descriptionController.text,
                      'ownerEmail': widget.ownerEmail,
                    }),
                  );

                  if (!context.mounted) return;
                  Navigator.pop(context, 'update');
                }
              },
              child: const Center(
                  child: Text('Add device', style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.bold),)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
