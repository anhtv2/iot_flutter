import 'package:SmartHome/src/screens/edit_device/components/body.dart';
import 'package:flutter/material.dart';

class EditDevice extends StatelessWidget {
  final String token;
  final String id;
  final String type;
  final String description;
  const EditDevice({Key? key, required this.id, required this.type, required this.description, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Body(id: id, type: type, description: description, token: token,),
      ),
    );
  }
}
