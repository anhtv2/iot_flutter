import 'package:SmartHome/src/screens/login_screen/components/body.dart';
import 'package:flutter/material.dart';
import 'package:SmartHome/config/size_config.dart';

class LoginScreen  extends StatelessWidget {
	const LoginScreen({Key? key}) : super(key: key);

	@override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      resizeToAvoidBottomInset:false,
	    body: Body(),
    );
  }
}
