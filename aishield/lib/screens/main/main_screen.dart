import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../constant.dart';

import '../home/home.dart';
import '../messages/messages.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    protectData();
    // await ScreenProtector.protectDataLeakageOn();
    super.initState();
  }

  @override
  void dispose() {
    ScreenProtector.protectDataLeakageOff();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: TabBarView(
            children: [
              Home(),
              Messages(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black45, blurRadius: 2, spreadRadius: 0)
          ], color: Colors.white),
          child: TabBar(
            labelColor: mainColor,
            indicatorColor: Colors.transparent,
            labelPadding: EdgeInsets.all(0.5),
            indicatorWeight: 1,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
            unselectedLabelColor: Colors.black45,
            tabs: [
              Tab(
                icon: Icon(LineAwesomeIcons.compass),
                iconMargin: EdgeInsets.only(bottom: 5),
                text: "Home",
              ),
              Tab(
                icon: Icon(LineAwesomeIcons.comment_dots),
                iconMargin: EdgeInsets.only(bottom: 5),
                text: "Messages",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> protectData() async {
  if (Platform.isAndroid) {
    await ScreenProtector.protectDataLeakageWithBlur();
  } else if (Platform.isIOS) {
    await ScreenProtector.protectDataLeakageWithBlur();
  }
}
