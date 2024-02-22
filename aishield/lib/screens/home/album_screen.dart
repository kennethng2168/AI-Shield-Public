import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../constant.dart';

class AlbumScreen extends ConsumerStatefulWidget {
  AlbumScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  @override
  _topBanner() {
    return Container(
      // padding: EdgeInsets.all(15.0),
      height: 300,
      decoration: BoxDecoration(
        color: mainColor,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                _topBanner(),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 55,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Album Collection",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.collections,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "2/4",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: 180,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.redeem,
                                    color: mainColor,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Redeem Now",
                                    style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () =>
                                // Navigator.of(context).pushNamed("/reportPage"),
                                print("Redeem Now"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        child: Text(
                          "Powered by Generative AI",
                          style: TextStyle(
                            decorationThickness: 1,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: 230,
                    right: 15,
                    left: 15,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(15),
                              child: Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/carbon.png"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Climate Change \n& Carbon Emission ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: 0.5,
                                      center: Text(
                                        "2/4",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/airpollution.jpeg"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Air & Water\n Pollution ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: 0.5,
                                      center: Text(
                                        "3/4",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                              ])),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(20),
                              child: Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/renewable.jpeg"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Renewable Energy \n(Solar)",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: 1,
                                      center: Text(
                                        "4/4",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/biodiversity.png"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Biodiversity\n Ecosystem",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: 1,
                                      center: Text(
                                        "4/4",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: mainColor,
                                    )
                                  ],
                                ),
                              ])),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: 2,
                right: 15,
                left: 15,
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
