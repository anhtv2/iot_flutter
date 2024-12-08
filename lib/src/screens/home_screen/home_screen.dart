import 'package:SmartHome/config/size_config.dart';
import 'package:SmartHome/src/screens/edit_profile/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../set_event_screen/set_event_screen.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String token;
  dynamic devices;

  HomeScreen({Key? key, required this.name, required this.devices, required this.email, required this.phone, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: getProportionateScreenHeight(60),
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                title: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(
                      4,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                          color: Color(0xffdadada),
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(45, 45)),
                        ),

                        child: IconButton(
                          splashRadius: 25,
                          icon: const Icon(
                            FontAwesomeIcons.solidUser,
                            color: Colors.amber,
                          ),
                          onPressed: () async {
                            String? status = await Navigator.push(context, MaterialPageRoute(builder: (context)
                            => EditProfile(name: name, email: email, phone: phone, token: token,),));

                            if (status != null) {
                              if(status == 'logout'){
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                      ),
                      Text(
                        'My home',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xffdadada),
                          borderRadius:
                          BorderRadius.all(Radius.elliptical(45, 45)),
                        ),

                        child: IconButton(
                          splashRadius: 25,
                          icon: const Icon(
                            CupertinoIcons.calendar,
                            color: Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SetEventScreen(),));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Body(devices: devices, token: token, ownerEmail: email,),
            ),
          );
  }
}
