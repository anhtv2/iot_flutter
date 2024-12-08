import 'package:SmartHome/src/screens/add_device/components/body.dart';
import 'package:flutter/material.dart';

class AddDevice extends StatelessWidget {
  final String ownerEmail;
  final String token;
  const AddDevice({Key? key, required this.token, required this.ownerEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Body(token: token, ownerEmail: ownerEmail,),
      ),
    );
  }
}
