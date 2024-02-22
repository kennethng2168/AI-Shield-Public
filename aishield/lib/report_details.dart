import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../utils/snackbars.dart';
import 'constant.dart';
import 'models/Detection.dart';

class ReportDetails extends ConsumerStatefulWidget {
  final Detection detection;
  ReportDetails({required this.detection, Key? key}) : super(key: key);

  @override
  ConsumerState<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends ConsumerState<ReportDetails> {
  bool dataMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onTap: Navigator.of(context).pop,
        ),
        title: Text(
          "Report Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // UserTopBar(
              //   leadingIconButton: IconButton(
              //     icon: const Icon(Icons.arrow_back),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
              const SizedBox(height: 15),
              Hero(
                tag: widget.detection.categories ?? "",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    widget.detection.detectionImageUrl ?? "",
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reported on ${widget.detection.timestamp}",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w300,
                      fontSize: 15),
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.detection.categories ?? "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   child: const Text(
              //     "Information",
              //     style: TextStyle(
              //         decoration: TextDecoration.underline,
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 25),
              //   ),
              // ),
              const SizedBox(
                height: 5,
              ),
              Container(
                // padding: EdgeInsets.only(
                //     // left: 10,
                //     // right: 15,
                //     ),
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Card(
                  color: Colors.white,
                  elevation: 8,
                  child: Container(
                    child: FlutterMap(
                      options: MapOptions(
                          center: LatLng(
                              double.parse(widget.detection.latitude),
                              double.parse(widget.detection.longitude)),
                          zoom: 18.0),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://mt0.google.com/vt/lyrs=s&hl=en&x={x}&y={y}&z={z}&s=Ga',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 30.0,
                              height: 30.0,
                              point: LatLng(
                                  double.parse(widget.detection.latitude),
                                  double.parse(widget.detection.longitude)),
                              child: Container(
                                child: widget.detection.categories == "Flood"
                                    ? Container(
                                        child: Icon(
                                          Icons.flood,
                                          color: mainColor,
                                          size: 40,
                                        ),
                                      )
                                    : widget.detection.categories == "Fire"
                                        ? Image.asset("assets/images/fire.png",
                                            color: Colors.red)
                                        : Icon(
                                            Icons.location_on,
                                            color: mainColor,
                                            size: 40,
                                          ),
                              ),
                            ),
                            Marker(
                              width: 30.0,
                              height: 30.0,
                              point: LatLng(3.1004, 101.6507),
                              child: Container(
                                child: Container(
                                  child: Image.asset(
                                    "assets/images/fire.png",
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Address",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.detection.address.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Row(
                children: [
                  Text(
                    "Latitude: ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.detection.latitude,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 15,
              // ),
              Row(
                children: [
                  Text(
                    "Longitude: ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.detection.longitude.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Thank you for reporting emergency case. We appreciate your help to build a more sustainable & safe communities.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
