import 'dart:convert';
import 'dart:io';

import 'package:SmartHome/config/size_config.dart';
import 'package:SmartHome/src/screens/home_screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
	const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
	bool passwordVisible = false;
	TextEditingController usernameController = TextEditingController();
	TextEditingController passwordController = TextEditingController();

	@override
  Widget build(BuildContext context) {
		Future<void> showLoginWarning() async {
			return showDialog<void>(
				context: context,
				barrierDismissible: false, // user must tap button!
				builder: (BuildContext context) {
					return AlertDialog(
						title: const Text('Login failed', style: TextStyle(color: Colors.red, fontSize: 24), textAlign: TextAlign.center,),
						content: const SingleChildScrollView(
							child: ListBody(
								children: <Widget>[
									SizedBox(height: 10),
									Text('Wrong username or password', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
								],
							),
						),
						actions: <Widget>[
							Center(
							  child: TextButton(
							  	child: const Text('Retry', style: TextStyle(color: Colors.blue, fontSize: 20)),
							  	onPressed: () {
							  		Navigator.of(context).pop();
							  	},
							  ),
							),
						],
					);
				},
			);
		}

    return Column(
	        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
				SizedBox(height: getProportionateScreenHeight(100)),
				Column(
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
				Container(
					width: 320,
					height: 320,
					decoration: BoxDecoration(
							border: Border.all(color: Colors.black54),
							borderRadius: BorderRadius.circular(20.0),
					),
					child: const Stack(
						children: [
							Positioned(
								left: 26,
								top: 148,
								child: SizedBox(
									width: 268,
									height: 70,
									child: Text(
										'Smart Home',
										textAlign: TextAlign.center,
										style: TextStyle(
											color: Colors.black,
											fontSize: 36,
											fontWeight: FontWeight.w400,
											height: 0,
										),
									),
								),
							),
							Positioned(
								left: 11.52,
								top: 249.60,
								child: SizedBox(
									width: 295.68,
									height: 60.16,
									child: Text(
										'Welcome home, login to manage your devices',
										textAlign: TextAlign.center,
										style: TextStyle(
											color: Colors.black,
											fontSize: 20,
											fontWeight: FontWeight.w400,
											height: 0,
										),
									),
								),
							),
							Positioned(
								left: 110,
								top: 33,
								child: Icon(
									CupertinoIcons.home,
									color: Colors.black,
									size: 100,
								),
							),
						],
					),
				),
				],
				),
				SizedBox(height: getProportionateScreenHeight(20)),
	          Padding(
		          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
		          child: TextFormField(
 			          controller: usernameController,
								autovalidateMode: AutovalidateMode.onUserInteraction,
								autofocus: false,
								keyboardType: TextInputType.text,
								validator: (value){
									if(value!.isEmpty || value.trim().isEmpty){
										return 'Username is required';
									}
									return null;
								},
								cursorColor: Colors.black12,
			          decoration: InputDecoration(
				          contentPadding: const EdgeInsets.only(left: 40.0, right: 20.0),
				          border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0),),
				          hintText: 'Username',
				          prefixIcon: const Icon(Icons.email, color: Colors.black,)
			          ),),
	          ),

				SizedBox(height: getProportionateScreenHeight(20)),

				Padding(
					padding: const EdgeInsets.only(left: 20.0, right: 20.0),
					child: TextFormField(
						controller: passwordController,
						autovalidateMode: AutovalidateMode.onUserInteraction,
						autofocus: false,
						keyboardType: TextInputType.text,
						obscureText: !passwordVisible,
						validator: (value){
							if(value!.isEmpty || value.trim().isEmpty){
								return 'Password is required';
							}
							return null;
						},
						decoration: InputDecoration(
							contentPadding: const EdgeInsets.only(left: 40.0, right: 20.0),
							border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0),),
							hintText: 'Password',
							prefixIcon: const Icon(Icons.lock, color: Colors.black,),
							suffixIcon: IconButton(
									onPressed: (){
										setState(() {
											passwordVisible = !passwordVisible;
										});
									},
									icon: const
									Icon(Icons.remove_red_eye, color: Colors.black,)
							),
						),),
				),

				SizedBox(height: getProportionateScreenHeight(20)),

				Padding(
					padding: const EdgeInsets.only(left: 20.0, right: 20),
					child: InkWell(
						onTap: () async {
							var response = await http.post(
								Uri.parse('https://iotbackend.vercel.app/login'),
								headers: <String, String>{
									'Content-Type': 'application/json; charset=UTF-8',
								},
								body: jsonEncode({
									'email': usernameController.text,
									'password': passwordController.text,
								}),
							);


							if(response.statusCode == 200){
								var data = jsonDecode(response.body);
								var name = data['data']['name'];
								var email = data['data']['email'];
								var phone = data['data']['phone'];
								String token = data['accessToken'];

								var deviceResponse = await http.get(
									Uri.https('iotbackend.vercel.app', 'api/device/get-all', {'ownerEmail': email}),
									headers: {
										HttpHeaders.authorizationHeader: "Bearer $token",
									},
								);

								var devices = jsonDecode(deviceResponse.body);

								if (!context.mounted) return;
								Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
										HomeScreen(name: name, email: email, phone: phone, token: token, devices: devices['data'])));
							}
							else{
								showLoginWarning();
							}
						},
						child: Container(
					width: double.infinity,
					padding: const EdgeInsets.all(16.0),
					decoration:BoxDecoration(
						color: Colors.black87,
						borderRadius:BorderRadius.circular(70.0), ),alignment: Alignment.center,
					child: const Text('Login in', style: TextStyle(color: Colors.white),),),
					),
				),
				SizedBox(height: getProportionateScreenHeight(10)),
				const Center(child: Text('Don\'t have an account yet? Contact our admin!'))
      ],
    );
  }
}
