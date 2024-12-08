import 'package:SmartHome/src/screens/edit_profile/components/body.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String token;
  const EditProfile({Key? key, required this.name, required this.email, required this.phone, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Body(name: name, email: email, phone: phone, token: token),
      ),
    );
  }
}
