import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../constant.dart';
import 'report_history.dart';
import 'report_page.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "Reports",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              LineAwesomeIcons.trash,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
        bottom: TabBar(
          physics: BouncingScrollPhysics(),
          controller: _tabController,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          labelColor: Colors.white,
          tabs: [
            Tab(
              text: "Form",
            ),
            Tab(
              text: "History",
            ),
          ],
        ),
      ),
      body: Container(
        child: TabBarView(
          physics: BouncingScrollPhysics(),
          controller: _tabController,
          children: [
            ReportPage(),
            ReportHistory(),
          ],
        ),
      ),
    );
  }
}
